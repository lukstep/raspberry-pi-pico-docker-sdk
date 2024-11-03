FROM ubuntu:24.10 AS gcc_build

# Build GCC RISC-V
COPY ./install_gcc.sh /home/install_gcc.sh
RUN bash /home/install_gcc.sh

FROM ubuntu:24.10 AS sdk_setup

RUN apt-get update -y && \
    apt-get upgrade -y && \
    apt-get install --no-install-recommends -y \
                       git \
                       ca-certificates \
                       python3 \
                       tar \
                       build-essential \
                       gcc-arm-none-eabi \
                       libnewlib-arm-none-eabi \
                       libstdc++-arm-none-eabi-newlib \
                       cmake && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Raspberry Pi Pico SDK
ARG SDK_PATH=/usr/local/picosdk
RUN git clone --depth 1 --branch 2.0.0 https://github.com/raspberrypi/pico-sdk $SDK_PATH && \
    cd $SDK_PATH && \
    git submodule update --init

ENV PICO_SDK_PATH=$SDK_PATH

# FreeRTOS
ARG FREERTOS_PATH=/usr/local/freertos
RUN git clone --depth 1 --branch V11.0.1 https://github.com/FreeRTOS/FreeRTOS-Kernel $FREERTOS_PATH && \
    cd $FREERTOS_PATH && \
    git submodule update --init --recursive

ENV FREERTOS_KERNEL_PATH=$FREERTOS_PATH

# Picotool installation
RUN git clone --depth 1 --branch 2.0.0 https://github.com/raspberrypi/picotool.git /home/picotool && \
    cd /home/picotool && \
    mkdir build && \
    cd build && \
    cmake .. && \
    make -j$(nproc) && \
    cmake --install . && \
    rm -rf /home/picotool

# Install GCC RISC-V
COPY --from=gcc_build /opt/riscv/gcc14-rp2350-no-zcmp /opt/riscv/gcc14-rp2350-no-zcmp
ENV PATH="$PATH:/opt/riscv/gcc14-rp2350-no-zcmp/bin"

