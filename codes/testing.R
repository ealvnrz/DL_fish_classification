# Directories ----

testing_augmented_images_path <- "../augmented_images/test/"

# Data Augmentation ----

## Configuration ----

seed <- 42
width <- 500
height <- 500
image_size <- c(width, height)

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

# Model ----

summary(model)

## Prediction on testing images ----

augmented_testing_images$reset()

testing_predictions <- model %>%
  predict(augmented_testing_images,
    steps = as.integer(augmented_testing_images$n)
  ) %>%
  k_argmax()

table(as.factor(as.array(testing_predictions)), as.factor(augmented_testing_images$classes))

cm <- confusionMatrix(data = as.factor(as.array(testing_predictions)), reference = as.factor(augmented_testing_images$classes))
cm

        

