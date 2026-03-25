FROM ubuntu:24.04

RUN apt-get update -y && \
    apt-get upgrade -y && \
    apt-get install --no-install-recommends -y \
        build-essential \
        ca-certificates \
        cmake \
        gcc-arm-none-eabi \
        git \
        libnewlib-arm-none-eabi \
        libstdc++-arm-none-eabi-newlib \
        python3 \
        tar \
        wget && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# RISC-V toolchain
ARG RISCV_VERSION=15.2.0-1
ARG TARGETARCH

RUN if [ "$TARGETARCH" = "arm64" ]; then \
        ARCH=linux-arm64; \
    elif [ "$TARGETARCH" = "amd64" ]; then \
        ARCH=linux-x64; \
    else \
        echo "Unsupported arch: $TARGETARCH" && exit 1; \
    fi && \
    wget -q https://github.com/xpack-dev-tools/riscv-none-elf-gcc-xpack/releases/download/v${RISCV_VERSION}/xpack-riscv-none-elf-gcc-${RISCV_VERSION}-${ARCH}.tar.gz \
        -O /tmp/riscv.tar.gz && \
    tar -xzf /tmp/riscv.tar.gz -C /opt && \
    rm /tmp/riscv.tar.gz

# Add toolchain to PATH
ENV PATH="/opt/xpack-riscv-none-elf-gcc-${RISCV_VERSION}/bin:${PATH}"

RUN TOOLCHAIN=/opt/xpack-riscv-none-elf-gcc-${RISCV_VERSION}/bin && \
    for f in $TOOLCHAIN/riscv-none-elf-*; do \
        name=$(basename $f | sed 's/riscv-none-elf/riscv32-unknown-elf/'); \
        ln -s $f /usr/local/bin/$name; \
    done

# Raspberry Pi Pico SDK
ARG SDK_PATH=/usr/local/picosdk
RUN git clone --depth 1 --branch 2.1.1 https://github.com/raspberrypi/pico-sdk $SDK_PATH && \
    cd $SDK_PATH && \
    git submodule update --init

ENV PICO_SDK_PATH=$SDK_PATH

# FreeRTOS
ARG FREERTOS_PATH=/usr/local/freertos
RUN git clone --depth 1 --branch V11.2.0 https://github.com/FreeRTOS/FreeRTOS-Kernel $FREERTOS_PATH && \
    cd $FREERTOS_PATH && \
    git submodule update --init --recursive

ENV FREERTOS_KERNEL_PATH=$FREERTOS_PATH

# Picotool installation
RUN git clone --depth 1 --branch 2.1.1 https://github.com/raspberrypi/picotool.git /home/picotool && \
    cd /home/picotool && \
    mkdir build && \
    cd build && \
    cmake .. && \
    make -j$(nproc) && \
    cmake --install . && \
    rm -rf /home/picotool
