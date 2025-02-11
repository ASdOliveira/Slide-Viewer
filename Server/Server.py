#!/usr/bin/env python

from argparse import ArgumentParser
import base64
from collections import OrderedDict
from io import BytesIO
import os
from threading import Lock
import zlib

from PIL import ImageCms
from flask import Flask, abort, make_response, render_template, url_for, jsonify, request

if os.name == 'nt':
    _dll_path = os.getenv('OPENSLIDE_PATH')
    if _dll_path is not None:
        with os.add_dll_directory(_dll_path):
            import openslide
    else:
        import openslide
else:
    import openslide

from openslide import OpenSlide, OpenSlideCache, OpenSlideError, OpenSlideVersionError
from openslide.deepzoom import DeepZoomGenerator

# Optimized sRGB v2 profile, CC0-1.0 license
# https://github.com/saucecontrol/Compact-ICC-Profiles/blob/bdd84663/profiles/sRGB-v2-micro.icc
# ImageCms.createProfile() generates a v4 profile and Firefox has problems
# with those: https://littlecms.com/blog/2020/09/09/browser-check/
SRGB_PROFILE_BYTES = zlib.decompress(
    base64.b64decode(
        'eNpjYGA8kZOcW8wkwMCQm1dSFOTupBARGaXA/oiBmUGEgZOBj0E2Mbm4wDfYLYQBCIoT'
        'y4uTS4pyGFDAt2sMjCD6sm5GYl7K3IkMtg4NG2wdSnQa5y1V6mPADzhTUouTgfQHII5P'
        'LigqYWBg5AGyecpLCkBsCSBbpAjoKCBbB8ROh7AdQOwkCDsErCYkyBnIzgCyE9KR2ElI'
        'bKhdIMBaCvQsskNKUitKQLSzswEDKAwgop9DwH5jFDuJEMtfwMBg8YmBgbkfIZY0jYFh'
        'eycDg8QthJgKUB1/KwPDtiPJpUVlUGu0gLiG4QfjHKZS5maWk2x+HEJcEjxJfF8Ez4t8'
        'k8iS0VNwVlmjmaVXZ/zacrP9NbdwX7OQshjxFNmcttKwut4OnUlmc1Yv79l0e9/MU8ev'
        'pz4p//jz/38AR4Nk5Q=='
    )
)
SRGB_PROFILE = ImageCms.getOpenProfile(BytesIO(SRGB_PROFILE_BYTES))

access_count = {"total": 0}
counter_lock = Lock()

CODE = "q7sxE*y3-eAJ!sw!vR#^"

class _SlideCache:
    def __init__(self, cache_size, tile_cache_mb, dz_opts, color_mode):
        self.cache_size = cache_size
        self.dz_opts = dz_opts
        self.color_mode = color_mode
        self._lock = Lock()
        self._cache = OrderedDict()
        # Share a single tile cache among all slide handles, if supported
        try:
            self._tile_cache = OpenSlideCache(tile_cache_mb * 1024 * 1024)
        except OpenSlideVersionError as error:
            self._tile_cache = None

    def get(self, path):
        with self._lock:
            if path in self._cache:
                # Move to end of LRU
                slide = self._cache.pop(path)
                self._cache[path] = slide
                return slide

        osr = OpenSlide(path)
        if self._tile_cache is not None:
            osr.set_cache(self._tile_cache)
        slide = DeepZoomGenerator(osr, **self.dz_opts)
        try:
            mpp_x = osr.properties[openslide.PROPERTY_NAME_MPP_X]
            mpp_y = osr.properties[openslide.PROPERTY_NAME_MPP_Y]
            slide.mpp = (float(mpp_x) + float(mpp_y)) / 2
        except (KeyError, ValueError):
            slide.mpp = 0
        slide.transform = self._get_transform(osr)

        with self._lock:
            if path not in self._cache:
                if len(self._cache) == self.cache_size:
                    self._cache.popitem(last=False)
                self._cache[path] = slide
        return slide

    def _get_transform(self, image):
        if image.color_profile is None:
            return lambda img: None
        mode = self.color_mode
        if mode == 'ignore':
            # drop ICC profile from tiles
            return lambda img: img.info.pop('icc_profile')
        elif mode == 'embed':
            # embed ICC profile in tiles
            return lambda img: None
        elif mode == 'absolute-colorimetric':
            intent = ImageCms.Intent.ABSOLUTE_COLORIMETRIC
        elif mode == 'relative-colorimetric':
            intent = ImageCms.Intent.RELATIVE_COLORIMETRIC
        elif mode == 'perceptual':
            intent = ImageCms.Intent.PERCEPTUAL
        elif mode == 'saturation':
            intent = ImageCms.Intent.SATURATION
        else:
            raise ValueError(f'Unknown color mode {mode}')
        transform = ImageCms.buildTransform(
            image.color_profile,
            SRGB_PROFILE,
            'RGB',
            'RGB',
            intent,
            0,
        )

        def xfrm(img):
            ImageCms.applyTransform(img, transform, True)
            # Some browsers assume we intend the display's color space if we
            # don't embed the profile.  Pillow's serialization is larger, so
            # use ours.
            img.info['icc_profile'] = SRGB_PROFILE_BYTES

        return xfrm


class _Directory:
    def __init__(self, basedir, relpath=''):
        self.name = os.path.basename(relpath)
        self.children = []
        for name in sorted(os.listdir(os.path.join(basedir, relpath))):
            cur_relpath = os.path.join(relpath, name)
            cur_path = os.path.join(basedir, cur_relpath)
            if os.path.isdir(cur_path):
                cur_dir = _Directory(basedir, cur_relpath)
                if cur_dir.children:
                    self.children.append(cur_dir)
            elif OpenSlide.detect_format(cur_path):
                self.children.append(_SlideFile(cur_relpath))

class _SlideFile:
    def __init__(self, relpath):
        self.name = os.path.basename(relpath)
        self.url_path = relpath


# Create and configure app
app = Flask(__name__)
app.config.from_mapping(
    SLIDE_DIR='./images/',
    SLIDE_CACHE_SIZE=7,
    SLIDE_TILE_CACHE_MB=128,
    DEEPZOOM_FORMAT='jpeg',
    DEEPZOOM_TILE_SIZE=254,
    DEEPZOOM_OVERLAP=1,
    DEEPZOOM_LIMIT_BOUNDS=True,
    DEEPZOOM_TILE_QUALITY=70,
    DEEPZOOM_COLOR_MODE='default',
)
app.config.from_envvar('DEEPZOOM_MULTISERVER_SETTINGS', silent=True)

# Set up cache
app.basedir = os.path.abspath(app.config['SLIDE_DIR'])
config_map = {
    'DEEPZOOM_TILE_SIZE': 'tile_size',
    'DEEPZOOM_OVERLAP': 'overlap',
    'DEEPZOOM_LIMIT_BOUNDS': 'limit_bounds',
}
opts = {v: app.config[k] for k, v in config_map.items()}
app.cache = _SlideCache(
    app.config['SLIDE_CACHE_SIZE'],
    app.config['SLIDE_TILE_CACHE_MB'],
    opts,
    app.config['DEEPZOOM_COLOR_MODE'],
)

# Helper functions
def get_slide(path):
    path = os.path.abspath(os.path.join(app.basedir, path))
    if not path.startswith(app.basedir + os.path.sep):
        # Directory traversal
        abort(404)
    if not os.path.exists(path):
        abort(404)
    try:
        slide = app.cache.get(path)
        slide.filename = os.path.basename(path)
        return slide
    except OpenSlideError:
        abort(404)

# Set up routes
@app.route('/count', methods=['POST'])
def increment_access():
    data = request.get_json()
    if not data or data.get("code") != CODE:
        return jsonify({"error": "Invalid or absent code"}), 403
    
    with counter_lock:
        access_count["total"] += 1
    return jsonify({"Status": "count incremented", "access number": access_count["total"]})

@app.route('/count_status')
def status():
    with counter_lock:
        access = access_count["total"]
    return jsonify({"access": access})

@app.route('/')
def index():
    return render_template('files.html', root_dir=_Directory(app.basedir))

@app.route('/<path:path>')
def slide(path):
    slide = get_slide(path)
    slide_url = url_for('dzi', path=path)
    return render_template(
        'slide-fullpage.html',
        slide_url=slide_url,
        slide_filename=slide.filename,
        slide_mpp=slide.mpp,
    )

@app.route('/<path:path>.dzi')
def dzi(path):
    slide = get_slide(path)
    format = app.config['DEEPZOOM_FORMAT']
    resp = make_response(slide.get_dzi(format))
    resp.mimetype = 'application/xml'
    return resp

@app.route('/<path:path>_files/<int:level>/<int:col>_<int:row>.<format>')
def tile(path, level, col, row, format):
    slide = get_slide(path)
    format = format.lower()
    if format != 'jpeg' and format != 'png':
        # Not supported by Deep Zoom
        abort(404)
    try:
        tile = slide.get_tile(level, (col, row))
    except ValueError:
        # Invalid level or coordinates
        abort(404)
    slide.transform(tile)
    buf = BytesIO()
    tile.save(
        buf,
        format,
        quality=app.config['DEEPZOOM_TILE_QUALITY'],
        icc_profile=tile.info.get('icc_profile'),
    )
    resp = make_response(buf.getvalue())
    resp.mimetype = 'image/%s' % format
    return resp

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, threaded=True)