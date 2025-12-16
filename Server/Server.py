from flask import Flask, render_template, abort, send_from_directory
import os

app = Flask(__name__,static_folder="./static")

SLIDES_FOLDER = "./images"

@app.route("/")
def health():
    return "OK"

@app.route("/<slide_name>")
def serve_slide(slide_name):
    slide_name = os.path.splitext(slide_name)[0]
    dzi_filename=f"{slide_name}.dzi"
    print("[SERVE_SLIDE] Searching for:" + dzi_filename)
    dzi_full_path = os.path.join(SLIDES_FOLDER, dzi_filename)

    if not os.path.exists(dzi_full_path):
        print("[ERROR] File not exists:" + dzi_full_path)
        abort(404)
    
    dzi_path = f"/slides/{dzi_filename}"
    
    return render_template("viewer.html", 
                           slide_name=slide_name,
                           dzi_path=dzi_path)

@app.route("/slides/<path:filename>")
def slides_static(filename):
    return send_from_directory(SLIDES_FOLDER, filename)

if __name__ == "__main__":
    app.run(host='0.0.0.0', port=5000, debug=False)
