# Packages ----

library(EBImage)
library(progress)
library(reticulate)
library(tidyverse)
library(tidymodels)
library(tensorflow)
library(keras)
library(caret)

# Working Directory ----

setwd("~")

# Python Configuration ----

python_dir <- ""
use_python(python_dir)

# Processes ----

## Image Resizing ----

source("image_resizing.R")

## Data Splitting ----

source("data_split.R")

## CNN Training ----

source("training.R")

## Adapted VGG16 CNN ----

source("pre_trained_models.R")

## Testing ----

### Model Choosing ----

model <- load_model_hdf5("50epoch_cnn.h5")
#model <- load_model_hdf5("50epoch_vgg.h5")

source("testing.R")