# install_tensorflow(version = "nightly") If needed
# GPU & Tensorflow ----

py_run_string("import tensorflow as tf")
py_run_string("print(len(tf.config.list_physical_devices('GPU')))")

tf$config$list_physical_devices("GPU")
tf$test$is_gpu_available()

training_images_path <- "../splitted_images/train/"
validation_images_path <- "../splitted_images/val/"
testing_images_path <- "../splitted_images/test/"
training_augmented_images_path <- "../augmented_images/train/"
validation_augmented_images_path <- "../augmented_images/val/"

# Data Augmentation ----

## Configuration ----

seed <- 42

### Training set ----

training_images_gen <- image_data_generator(
  rescale = 1 / 255,
  rotation_range = 50,
  width_shift_range = 0.3,
  height_shift_range = 0.3,
  shear_range = 0.3,
  zoom_range = 0.3,
  horizontal_flip = TRUE,
  fill_mode = "nearest"
)

### Validation set ----

validation_images_gen <- image_data_generator(
  rescale = 1 / 255
)

## Functions ----

width <- 500
height <- 500
image_size <- c(width, height)

### Training ----

augmented_training_images <- flow_images_from_directory(
  directory = training_images_path,
  generator = training_images_gen,
  target_size = image_size,
  class_mode = "categorical",
  classes = sp_dir,
  save_to_dir = training_augmented_images_path,
  seed = seed
)

### Validation ----

augmented_validation_images <- flow_images_from_directory(
  directory = validation_images_path,
  generator = validation_images_gen,
  target_size = image_size,
  class_mode = "categorical",
  classes = sp_dir,
  save_to_dir = validation_augmented_images_path,
  seed = seed
)

# Sample Information ----

## Training ----

augmented_training_images$class_indices

table(factor(augmented_training_images$classes))

## Validation ----

augmented_validation_images$class_indices

table(factor(augmented_validation_images$classes))

## Sample Size ----

training_size <- augmented_training_images$n

validation_size <- augmented_validation_images$n

# Neural Network ----

batch_size <- 32
channels <- 3
n_classes <- length(sp_dir)
epochs <- 50

## Configuration ----

nnet_model <- keras_model_sequential() %>%
  layer_conv_2d(filter = 32, kernel_size = c(3, 3), padding = "same", activation = "relu", input_shape = c(width, height, channels)) %>%
  layer_max_pooling_2d(pool_size = c(2, 2)) %>%
  layer_conv_2d(filters = 64, kernel_size = c(3, 3), activation = "relu") %>%
  layer_max_pooling_2d(pool_size = c(2, 2)) %>%
  layer_conv_2d(filters = 64, kernel_size = c(3, 3), activation = "relu") %>%
  layer_max_pooling_2d(pool_size = c(2, 2)) %>%
  layer_conv_2d(filters = 128, kernel_size = c(3, 3), activation = "relu") %>%
  layer_max_pooling_2d(pool_size = c(2, 2)) %>%
  layer_conv_2d(filters = 128, kernel_size = c(3, 3), activation = "relu") %>%
  layer_max_pooling_2d(pool_size = c(2, 2)) %>%
  layer_dropout(0.25) %>%
  layer_flatten() %>%
  layer_dense(100) %>%
  layer_activation("relu") %>%
  layer_dropout(0.25) %>%
  layer_dense(n_classes) %>%
  layer_activation("softmax")

## Compilation ----

nnet_model %>% compile(
  loss = "categorical_crossentropy",
  optimizer = optimizer_rmsprop(learning_rate = 0.0001),
  metrics = "accuracy"
)

## Fit ----

tensorboard("/logs")

hist <- nnet_model %>%
  fit(augmented_training_images,
    steps_per_epoch = as.integer(training_size / batch_size),
    epochs = epochs,
    validation_data = augmented_validation_images,
    validation_steps = as.integer(validation_size / batch_size),
    verbose = 1,
    callbacks = list(
      callback_model_checkpoint("model_checkpoint/model_checkpoints.h5", save_best_only = TRUE),
      callback_tensorboard(log_dir = "/logs")
    )
  )

nnet_model %>% save_model_hdf5("50epoch_cnn.h5")

