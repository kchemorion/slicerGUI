import os
import slicer

# Directory inside the container where images are stored
image_directory = '/images'
image_files = [os.path.join(image_directory, f) for f in os.listdir(image_directory) if f.endswith('.jpeg')]

# Load the images
for image_file in image_files:
    slicer.util.loadVolume(image_file, {'singleFile': False})

# Set the desired directory for saving files
slicer.app.settings().setValue("IO/DefaultWriteDirectory", "/root/Documents")

slicer.util.mainWindow().moduleSelector().selectModule('Markups')

slicer.app.settings().sync()