# Deep learning-based classification of species in central-southern fisheries in Chile

Supplementary material to **Deep learning-based classification of species in central-southern fisheries in Chile** by Eloy Alvarado, Francisco Plaza-Vega, Carlos Montenegro, Oscar Saavedra.

Code written by: Eloy Alvarado, with contributions of Francisco Plaza-Vega.

Code tested on:

- R version 4.3.1 & Python 3.11.5 (reticulate), running Arch Linux 6.5.7 (64 bits server) 

 ## Project structure

- augmented_images: Empty folder for augmented images.
- codes
    - ```data_split.R```: Images splitting into training, validation and testing sets.
    - ```image_resizing.R```: Image resizing.
    - ```main.R```: Configuration file.
    - ```pre_trained_models.R```: Adapted VGG16 convolutional neural network.
    - ```testing.R```: Testing Custom and Adapted VGG16 CNN on testing images.
    - ```training.R```: Custom convolutional neural network.
- LICENSE: CC0 1.0 Universal
- raw_images: Empty folder for raw images. 
- README.md: This file.
- resized_images: Empty folder for resized images. Needed for ```image_resizing.R```.
- splitted_images: Empty folder for splitted imaged. Needed for ```data_split.R```.

## Raw images

Raw images used in this research article can be access as per request in ```<url>```.

### Species codification

| #   | Species                 |
|-----|-------------------------|
| 0   | Apristurus nasutus      |
| 1   | Brama australis         |
| 2   | Caelorincus fasciatus   |
| 3   | Cilus gilberti          |
| 4   | Eleginops maclovinus    |
| 5   | Engraulis ringens       |
| 6   | Epigonus crassicaudus   |
| 7   | Genypterus chilensis    |
| 8   | Genypterus maculatus    |
| 9   | Merluccius gayi gayi    |
| 10  | Paralichthys microps    |
| 11  | Scomber japonicus       |
| 12  | Seriolella punctata     |
| 13  | Strangomera bentincki   |
| 14  | Stromateus stellatus    |
| 15  | Thyrsites atun          |
| 16  | Bovichtus chilensis     |
| 17  | Trachurus murphyi       |

## Configuration

1. Request access to raw images as detailed in [Raw images section]{#raw-images}
2. Copy all images into the raw_images folder
3. In the ```main.R``` file:
   - Set the codes folder as working directory
   - Replace ```python_dir <- ""```with your local python binary.
4. Run ```main.R``` file to train the Custom CNN and Adapted VGG16 classification model. This process will create 2 file in the working directory (```50epoch_cnn.h5``` and ```50epoch_vgg.h5```)
5. By default, ```main.R``` file only consider  the Custom CNN model for testing. Uncomment line 44 (and comment line 43) in the file to test the Adapted VGG16 model.
  


