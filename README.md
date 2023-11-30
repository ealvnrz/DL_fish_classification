# Deep learning-based classification of species in central-southern fisheries in Chile

Supplementary material to **Deep learning-based classification of species in central-southern fisheries in Chile** by Eloy Alvarado, Francisco Plaza-Vega, Carlos Montenegro, Oscar Saavedra.

Code written by: Eloy Alvarado, with contributions of Francisco Plaza-Vega.

Code tested on:

- R version 4.3.1, running Arch Linux 6.5.7 (64 bits server)

 ## Project Structure:

├── augmented_images: Empty folder for augmented images.
├── codes
│   ├── ```data_split.R```: Images splitting into training, validation and testing sets.
│   ├── ```image_resizing.R```: Image resizing.
│   ├── ```main.R```: Configuration file.
│   ├── ```pre_trained_models.R```: Adapted VGG16 convolutional neural network.
│   ├── ```testing.R```: Testing Custom and Adapted VGG16 CNN on testing images.
│   └── ```training.R```: Custom convolutional neural network.
├── LICENSE: CC0 1.0 Universal
├── raw_images: Empty folder for raw images. Images available in ```<url>```.
├── README.md: This file.
├── resized_images: Empty folder for resized images. Needed for ```image_resizing.R```.
└── splitted_images: Empty folder for splitted imaged. Needed for ```data_split.R```.
