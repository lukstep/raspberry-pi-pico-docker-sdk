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

## Attach VSCode to running container

You can use the SDK container with Visual Studio Code, follow the instruction below:

1. Install [Visual Studio Code](https://code.visualstudio.com) and next [Remote Development](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.vscode-remote-extensionpack) extensions.

![image-1](https://user-images.githubusercontent.com/20487002/201380432-da387680-f6b0-4542-8c02-6a3eec8e103d.png)

2. Open the terminal and go to the projects you want to open in VSCode.

3. Pool SDK image from Docker HUB and run SDK container via the following command. The container must be running while you attach to it via VSCode.

```
docker run -d -it --name pico-sdk --mount type=bind,source=${PWD},target=/home/dev lukstep/raspberry-pi-pico-sdk:latest

docker exec -it pico-sdk /bin/sh
```

4. Click the green button in the lower left corner of VSCode and select options: Attach to Running Container...

![imag-2](https://user-images.githubusercontent.com/20487002/201382466-0204a11c-8487-4da5-8a3c-2c9cc233333c.png)

![imag-3](https://user-images.githubusercontent.com/20487002/201382561-41e4c75e-3424-4c50-99ac-f6bc76ec6892.png)

5. Select the SDK container.

![imag-4](https://user-images.githubusercontent.com/20487002/201383009-54a3fc62-1206-4105-83d0-d956448434dd.png)

6. Then a new VSCode window will open. At the bottom window, you can see that it is attached to the SDK container.

![imag-5](https://user-images.githubusercontent.com/20487002/201383452-10573842-de2a-46c3-9ebf-f6fd5f06c687.png)

7. Now, there is needed to open project files. Your project is mounted to `/home/dev` in the container. Go to EXPLORE tab in VSCode and click Open Folder. In opened window write `/home/dev` and click the OK button.

![imag-6](https://user-images.githubusercontent.com/20487002/201386202-dd0934b2-5fae-4a2d-8875-f2cb40b1dc59.png)

8. Now You can explore, develop and build your Raspberry Pi Pico project via Visual Studio Code!

![imag-7](https://user-images.githubusercontent.com/20487002/201389505-d1346622-a8e1-4d0b-842c-57e5b54f9183.png)
