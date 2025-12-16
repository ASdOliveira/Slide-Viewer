import os 
import subprocess

input_dir = "./images"
output_dir = "./images_copied"

for filename in os.listdir(input_dir):
    if filename.endswith(".mrxs"):
        slide_path= os.path.join(input_dir, filename)
        slide_name = os.path.splitext(filename)[0]

        out_path = os.path.join(output_dir,slide_name)
        os.makedirs(out_path,  exist_ok=True)

        print(f"Convertendo {filename} -> {out_path}")

        subprocess.run(["python3", "deepzoom_tile.py",
                        "--format=jpeg", "--size=254","--overlap=1",
                        f"--output={out_path}",slide_path])
        
