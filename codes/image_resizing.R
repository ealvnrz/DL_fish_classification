# Raw Images Directory ----

image_dir <- "../raw_images"
resized_image_dir <- "../resized_images"
sp_dir <- list.dirs(image_dir)
sp_dir <- sp_dir[-1]
sp_dir_resized <- list.dirs(resized_image_dir)
sp_dir_resized <- sp_dir_resized[-1]

# Target size ----

width <- 500
height <- 500

# Resizing function ----

pb <- progress_bar$new(total = length(sp_dir))

resize_images <- function() {
  pb$tick(len = 0)
  Sys.sleep(0.5)
  pb$tick(len = 0)
  for (j in 1:length(sp_dir)) {
    files <- list.files(sp_dir[j])
    pb$tick()
    for (i in 1:length(files)) {
      img <- readImage(file.path(sp_dir[j], files[i]))
      img_resized <- resize(img, w = width, h = height)
      writeImage(img_resized, paste0(sp_dir_resized[j], "/", files[i]))
      i <- i + 1
    }
    j <- j + 1
  }
}

resize_images()
