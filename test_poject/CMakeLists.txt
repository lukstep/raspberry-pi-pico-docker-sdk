cmake_minimum_required(VERSION 3.13)

include($ENV{PICO_SDK_PATH}/pico_sdk_init.cmake)
project(sample C CXX ASM)

set(CMAKE_C_STANDARD 11)
set(CMAKE_CXX_STANDARD 17)

pico_sdk_init()

add_executable(sample main.c)

pico_enable_stdio_usb(sample 1)
pico_enable_stdio_uart(sample 1)
pico_add_extra_outputs(sample)

target_link_libraries(sample pico_stdlib)
