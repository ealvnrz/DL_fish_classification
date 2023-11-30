# Splitted Images Directory ----

splitted_image_dir <- "../splitted_images/"

# Python script via reticulate ----

import("splitfolders")

py_run_string("import splitfolders")
py_run_string("input_folder = r.resized_image_dir")
py_run_string("output_folder = r.splitted_image_dir")
py_run_string("splitfolders.ratio(input_folder, output= output_folder, seed=42, ratio = (0.7, 0.2, 0.1))")
