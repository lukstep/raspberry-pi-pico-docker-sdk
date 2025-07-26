[![Raspberry PI Pico Docker SDK CI](https://github.com/lukstep/raspberry-pi-pico-docker-sdk/actions/workflows/sdk-ci.yml/badge.svg)](https://github.com/lukstep/raspberry-pi-pico-docker-sdk/actions/workflows/sdk-ci.yml)

# Raspberry Pi Pico Docker SDK

A SDK environment for Raspberry Pi Pico 1 and 2 in a Docker container.

## Pulling the Image from Docker Hub and Running

The latest image is available on [Docker Hub](https://hub.docker.com/repository/docker/lukstep/raspberry-pi-pico-sdk/general)
and can be used to run a container.
The following commands show how to run the container using the Docker Hub image:

```bash
docker run -d -it --name pico-sdk --mount type=bind,source=${PWD},target=/home/dev lukstep/raspberry-pi-pico-sdk:latest
docker exec -it pico-sdk /bin/sh
```

The directory from which the `docker run` command was executed will be mounted in the container at `/home/dev`.
After attaching to the SDK container, you can build your project by executing the following steps:

```bash
cd /home/dev
mkdir build
cd build
cmake .. && make -j4
```

## Building the Image and Running the Container

To build your own SDK image, clone this repository and run the following commands:

```bash
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

- Clone [pico-template-project](https://github.com/lukstep/pico-template-project) repository.
- Open `pico-template-project` folder in Visual Studio Code.
- In VSCode, click the button in the bottom left corner of VSCode and select: Reopen in Container...
![image-1](https://github.com/lukstep/raspberry-pi-pico-docker-sdk/assets/20487002/f1f06bca-cb0b-4c2d-bf4c-611ef004e70a)
- Build the project.
- Enjoy coding you Pico project with Intellisense.
![image-1](https://github.com/lukstep/raspberry-pi-pico-docker-sdk/assets/20487002/ed367c06-aa9f-440a-9ca2-ddfbd7bdd266)

## Pico Memory Flashing and Debugging via Pico Probe and OpenOCD

> [!WARNING]  
> OpenOCD not support RP2350 (Pico 2). Currently this part is only valid for RP2040 boards (Pico 1).

To work efficiently on the project, we need the ability to upload firmware to the microcontroller, debug, and communicate through the serial port. The Raspberry Pi Pico board itself allows for software uploads, but this process is not very convenient or efficient for larger projects. The Pico Probe extends the capabilities of the Raspberry Pi Pico board to include fast firmware uploads to the microcontroller's memory, debugging via Serial Wire Debug (SWD), and it also serves as a USB UART converter.

The Debug Probe is compatible with the CMSIS-DAP interface, allowing OpenOCD to be used as the debugger server. By using OpenOCD, it becomes possible to communicate between development containers and the Debug Probe via TCP. On Linux, the Docker container can communicate directly through COM ports. However, on Mac and Windows, this is not possible because Docker runs in a dedicated virtual machine that does not have access to COM ports. Therefore, a solution with the OpenOCD server on the host machine was chosen.

The diagram below shows the environment topology:

1. Pico Probe is connected to the Raspberry Pi Pico board:

    - SWD (Serial Wire Debug) interface for debugging.
    - UART (Universal Asynchronous Receiver/Transmitter) interface for serial communication.

2. The Pico Probe is connected to the PC via USB.

3. OpenOCD (Open On-Chip Debugger) runs on the PC and communicates with the Pico Probe.

4. The development container (devContainer) connects to OpenOCD via TCP.

![image-1](https://github.com/lukstep/raspberry-pi-pico-docker-sdk/assets/20487002/27bbb17d-5de4-4e41-9481-17a9e249e7b3)

### Install required tools

To install OpenOCD on Linux, run the following command in a terminal:

```bash
sudo apt install openocd
```

To install OpenOCD on macOS, run the following command:

```bash
brew install openocd
```

To install OpenOCD on Windows, follow these steps:

- Go to the page https://github.com/xpack-dev-tools/openocd-xpack/releases.

- Download the Windows build of OpenOCD. For example, you might download a file named xpack-openocd-0.12.0-2-win32-x64.zip.

- Unzip the downloaded file to extract its contents.

### How to Use: Step-by-Step Instructions

1. Connect the Pico Probe to the Pico Board via SWD (1) and connect the Pico board UART to the UART-USB converter on the Pico Probe (2).
   
![image-1](https://github.com/lukstep/raspberry-pi-pico-docker-sdk/assets/20487002/92974093-0699-4299-b88c-b15633cee616)

2. Connect the Pico Probe and Pico Board to your PC
   
3. Start the OpenOCD

    On Linux and Mac, open a new terminal and run the following command:

    ```bash
    sudo openocd -f interface/cmsis-dap.cfg -f target/rp2040.cfg -c 'bindto 0.0.0.0' -c 'adapter speed 5000' -c 'init'
    ```

    On Windows, open PowerShell, navigate to the folder containing OpenOCD, and run `openocd.exe`:

    ```bash
    cd .\Desktop\xpack-openocd-0.12.0-2\
    .\bin\openocd.exe -f interface\cmsis-dap.cfg -f target\rp2040.cfg -c 'bindto 0.0.0.0' -c 'adapter speed 5000' -c 'init'
    ```

4. Open the project in the Dev Container.

5. Make a debug build. Go to the CMake extension tab (1), click "Select Variant" (2), and choose "Debug" build (3). Start the build (4). If the build completes successfully, you can proceed to flashing the memory and debugging.

![image-1](https://github.com/lukstep/raspberry-pi-pico-docker-sdk/assets/20487002/262fb68b-8ef5-4ec2-a05e-8fd09597915d)

6. To start a debug session, first add a breakpoint in the main function. Next, go to the debugger extension tab (1), and click "Play" (2). The debug session starts by flashing the Pico's memory and restarting the microcontroller. After the reset, the flashed firmware starts and the program should stop at the breakpoint.

![image-1](https://github.com/lukstep/raspberry-pi-pico-docker-sdk/assets/20487002/598f6508-0b9a-44dc-b1f9-3a9eb391f0c3)

It is possible to flash the Pico's memory without starting a debugger session. To do that, run the preprogrammed tasks.

- Press Ctrl+Shift+P (Windows/Linux) or Cmd+Shift+P (Mac) to open the Command Palette.
- Type Run Task into the Command Palette and press Enter.
- Select task `Flash`.

## Manual configuration of VSCode as Pico IDE (old)

Refer [here](docs/vscode_manual_setup.md) for step-by-step instruction

## References

[Raspberry Pi Debug Probe](https://www.raspberrypi.com/documentation/microcontrollers/debug-probe.html)

[Raspberry Pi Pico C/C++ SDK](https://datasheets.raspberrypi.com/pico/raspberry-pi-pico-c-sdk.pdf)

[OpenOCD project page](https://openocd.org)
