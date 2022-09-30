# Raspberry Pi Pico Docker SDK

Lightweight Raspberry Pi Pico C++ SDK container.

## Pull container from Docker Hub and run

The latest version of the image is stored on [Docker Hub](https://hub.docker.com/repository/docker/lukstep/raspberry-pi-pico-sdk/general)
and can be used for container runs.
Commands below show how to run a container, using an image from Docker Hub
```
docker run -d -it --name pico-sdk --mount type=bind,source=${PWD},target=/home/dev lukstep/raspberry-pi-pico-sdk:latest

docker exec -it pico-sdk /bin/sh
```

The directory from which the `docker run` command was called will be mounted to /home/dev in the container. 
So after attaching to the SDK container you can build your project following the steps:

```
cd /home/dev

mkdir build

cd build

cmake .. && make -j4
```

## Build image and run container:

To build your own SDK image, You need to clone this repository and run the following commands:

```
cd raspberry-pi-pico-docker-sdk

docker build . --tag pico-sdk

docker run -d -it --name pico-sdk --mount type=bind,source=${PWD},target=/home/dev pico-sdk

docker exec -it pico-sdk /bin/sh
```

