# Slicer Docker Container

This Dockerfile creates a Docker container with an Ubuntu desktop environment that includes VNC and noVNC/web access. In this environment, the 3D Slicer application is installed and configured to run.

## Background

This Docker container is based on the `dorowu/ubuntu-desktop-lxde-vnc:bionic` image, which provides an Ubuntu desktop environment accessible via VNC and noVNC/web. The 3D Slicer application is installed and configured to run within this environment. Additionally, a custom script is provided to start 3D Slicer and maximize its window upon container startup.

## Prerequisites

Before building the Docker container, ensure you have:

1. Docker installed on your system.
2. Downloaded the 3D Slicer application and placed it in the `Slicer/` directory. The `Slicer/` directory should be in the same directory as the Dockerfile.

## Building the Docker Container

To build the Docker container, navigate to the directory containing the Dockerfile and run the following command:

```bash
docker build -t slicer-container .
```

## Running the Docker Container

Once the Docker container is built, you can run it using the following command:

```bash
docker run -p 6080:80 -p 5900:5900 slicer-container
```

This command maps port 6080 (noVNC/web access) and port 5900 (VNC) to the corresponding ports in the Docker container.

## Accessing 3D Slicer

To access 3D Slicer:

1. Open a web browser and navigate to `http://localhost:6080`.
2. You will be presented with a desktop environment.
3. Open the 3D Slicer application from the desktop environment.

## Important Notes

- Ensure you have downloaded the 3D Slicer application and placed it in the `Slicer/` directory before building the Docker container.
- The provided `slicerrc.py` script is executed when 3D Slicer starts and loads images from the `/images` directory into the application.
- The `VOLUME` directive in the Dockerfile maps the `/root/Documents` and `/images` directories on the host machine to the corresponding directories in the Docker container. You can use these directories to access files and images within the container.
