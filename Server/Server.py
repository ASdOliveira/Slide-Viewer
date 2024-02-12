#!/usr/bin/env python

from argparse import ArgumentParser
import base64
from collections import OrderedDict
from io import BytesIO
import os
from threading import Lock
import zlib

from PIL import ImageCms
from flask import Flask, abort, make_response, render_template, url_for

if os.name == 'nt':
    _dll_path = os.getenv('OPENSLIDE_PATH')
    if _dll_path is not None:
        with os.add_dll_directory(_dll_path):
            import openslide
    else:
        import openslide
else:
    import openslide

from openslide import OpenSlide, OpenSlideError
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

app = Flask(__name__)
app.config.from_mapping(
    SLIDE_DIR='./images',
    DEEPZOOM_FORMAT='jpeg',
    DEEPZOOM_TILE_SIZE=254,
    DEEPZOOM_OVERLAP= 10, #1,
    DEEPZOOM_LIMIT_BOUNDS=False,
    DEEPZOOM_TILE_QUALITY= 100, #75,
    DEEPZOOM_COLOR_MODE='absolute-colorimetric',
)
app.config.from_envvar('DEEPZOOM_MULTISERVER_SETTINGS', silent=True)


app.basedir = os.path.abspath(app.config['SLIDE_DIR'])
config_map = {
    'DEEPZOOM_TILE_SIZE': 'tile_size',
    'DEEPZOOM_OVERLAP': 'overlap',
    'DEEPZOOM_LIMIT_BOUNDS': 'limit_bounds',
}

def get_transform(image):
    if image.color_profile is None:
        return lambda img: None
    mode = app.config['DEEPZOOM_COLOR_MODE']

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
        0)

# Helper functions
def get_slide(path):
    path = os.path.abspath(os.path.join(app.basedir, path))
    if not path.startswith(app.basedir + os.path.sep):
        # Directory traversal
        abort(404)
    if not os.path.exists(path):
        abort(404)
    try:
        osr = OpenSlide(path)
        slide = DeepZoomGenerator(osr = osr,
                                  limit_bounds = app.config['DEEPZOOM_LIMIT_BOUNDS'],
                                  overlap = app.config['DEEPZOOM_OVERLAP'],
                                  tile_size = app.config['DEEPZOOM_TILE_SIZE'])
        
        mpp_x = osr.properties[openslide.PROPERTY_NAME_MPP_X]
        mpp_y = osr.properties[openslide.PROPERTY_NAME_MPP_Y]
        slide.mpp = (float(mpp_x) + float(mpp_y)) / 2
        slide.transform = get_transform(osr)

        slide.filename = os.path.basename(path)
        return slide
    except OpenSlideError:
        abort(404)

# Set up routes
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
    app.run(host='0.0.0.0', port='5000', threaded=True)

