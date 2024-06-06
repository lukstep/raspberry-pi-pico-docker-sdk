[![Raspberry PI Pico Docker SDK CI](https://github.com/lukstep/raspberry-pi-pico-docker-sdk/actions/workflows/sdk-ci.yml/badge.svg)](https://github.com/lukstep/raspberry-pi-pico-docker-sdk/actions/workflows/sdk-ci.yml)

# Raspberry Pi Pico Docker SDK

A lightweight SDK environment for Raspberry Pi Pico in a Docker container.

## Pulling the Image from Docker Hub and Running

The latest image is available on [Docker Hub](https://hub.docker.com/repository/docker/lukstep/raspberry-pi-pico-sdk/general)
and can be used to run a container.
The following commands show how to run the container using the Docker Hub image:

```
docker run -d -it --name pico-sdk --mount type=bind,source=${PWD},target=/home/dev lukstep/raspberry-pi-pico-sdk:latest
docker exec -it pico-sdk /bin/sh
```

The directory from which the `docker run` command was executed will be mounted in the container at `/home/dev`.
After attaching to the SDK container, you can build your project by executing the following steps:

```
cd /home/dev
mkdir build
cd build
cmake .. && make -j4
```

## Building the Image and Running the Container

To build your own SDK image, clone this repository and run the following commands:

```
cd raspberry-pi-pico-docker-sdk
docker build . --tag pico-sdk
docker run -d -it --name pico-sdk --mount type=bind,source=${PWD},target=/home/dev pico-sdk
docker exec -it pico-sdk /bin/sh
```

## Visual Studio Code as IDE for Raspberry Pi Pico Projects

You can use the SDK container with Visual Studio Code to create an IDE for Raspberry Pi Pico projects.
There are two solutions prepared: a new one using the Visual Studio Dev Containers extension and an old one with manual configuration.

### [Visual Studio Code Dev Container](https://code.visualstudio.com/docs/devcontainers/containers)

#### Prerequisites

To use the dev container, you need to have VSCode, Docker, and the VSCode extensions installed.
Follow [this](https://code.visualstudio.com/docs/devcontainers/tutorial#_prerequisites) guide for setup.

#### Using the Dev Container for Pico IDE

 - Clone [pico-dev-container](https://github.com/lukstep/pico-dev-container/tree/main) repository.
 - Open `pico-dev-container` folder in Visual Studio Code.
 - In VSCode, click the button in the bottom left corner of VSCode and select: Reopen in Container...
![image-1](https://github.com/lukstep/raspberry-pi-pico-docker-sdk/assets/20487002/f1f06bca-cb0b-4c2d-bf4c-611ef004e70a)
 - Build the project.
 - Enjoy coding you Pico project with Intellisense.
![image-1](https://github.com/lukstep/raspberry-pi-pico-docker-sdk/assets/20487002/ed367c06-aa9f-440a-9ca2-ddfbd7bdd266)

### Manual configuration of VSCode as Pico IDE (old)

Refer [here](docs/vscode_manual_setup.md) for step-by-step instruction

