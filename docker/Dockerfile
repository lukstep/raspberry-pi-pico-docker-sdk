FROM alpine:3.16.2

# Install toolchain
RUN apk update && \
    apk upgrade && \
    apk add git \
            python3 \
            py3-pip \
            cmake \
            build-base \
            libusb-dev \
            bsd-compat-headers \
            newlib-arm-none-eabi \
            gcc-arm-none-eabi

# Raspberry Pi Pico SDK
RUN git clone https://github.com/raspberrypi/pico-sdk /usr/pico-sdk && \
    cd /usr/pico-sdk  && \
    git submodule update --init

ENV PICO_SDK_PATH=/usr/pico-sdk

# Picotool installation
RUN git clone -b master https://github.com/raspberrypi/picotool.git /usr/picotool && \
    cd /usr/picotool && \
    mkdir build && \
    cd build && \
    cmake .. && \
    make && \
    cp /usr/picotool/build/picotool /bin/picotool && \
    rm -rf /usr/picotool
