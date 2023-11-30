
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

# Data Augmentation ----
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

### Validation set ----

validation_images_gen <- image_data_generator(
  rescale = 1 / 255
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
  
## Testing ----

testing_images_gen <- image_data_generator(
  rescale = 1 / 255
)

augmented_testing_images <- flow_images_from_directory(
  directory = testing_images_path,
  generator = testing_images_gen,
  target_size = image_size,
  class_mode = "categorical",
  classes = sp_dir,
  batch_size = 1,
  shuffle = FALSE,
  save_to_dir = testing_augmented_images_path,
  seed = seed
)

## Classes frequency ----

classes <- augmented_testing_images$classes %>%
  factor() %>%
  table() %>%
  as_tibble() %>%
  rename("value" = ".")

indices <- augmented_testing_images$class_indices %>%
  as.data.frame() %>%
  gather() %>%
  mutate(value = as.character(value)) %>%
  left_join(classes, by = "value")

## Sample Size ----

training_size <- augmented_training_images$n

validation_size <- augmented_validation_images$n

# Neural Network ----

batch_size <- 32
channels <- 3
n_classes <- length(sp_dir)
epochs <- 50


# Model ----

base_model <- application_vgg16(
  weights = 'imagenet',
  include_top = FALSE,
)

summary(base_model)


predictions <- base_model$output %>% 
  layer_conv_2d(filters = 64, kernel_size = c(3, 3), activation = "relu") %>%
 layer_global_average_pooling_2d(trainable = T) %>% 
 layer_dense(64, trainable = T) %>%
 layer_activation("relu", trainable = T) %>%
 layer_dropout(0.4, trainable = T) %>%
 layer_dense(18, trainable=T) %>%   
 layer_activation("softmax", trainable=T)


model <- keras_model(inputs = base_model$input, outputs = predictions)

summary(model)

for (layer in base_model$layers)
   layer$trainable <- FALSE

model %>% compile(
   loss = "categorical_crossentropy",
   optimizer = optimizer_rmsprop(learning_rate = 0.002),
   metrics = "accuracy"
 )
hist <- model %>% fit(
   augmented_training_images,
   steps_per_epoch = as.integer(training_size / batch_size),
   epochs = 50,
   validation_data = augmented_validation_images,
   validation_steps = as.integer(validation_size / batch_size),
   verbose=2
 )

model %>% save_model_hdf5("50epoch_vgg.h5")




