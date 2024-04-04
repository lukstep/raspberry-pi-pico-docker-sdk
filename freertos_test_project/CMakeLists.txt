cmake_minimum_required(VERSION 3.13)

include($ENV{PICO_SDK_PATH}/external/pico_sdk_import.cmake)
include($ENV{FREERTOS_KERNEL_PATH}/portable/ThirdParty/GCC/RP2040/FreeRTOS_Kernel_import.cmake)

set(CMAKE_C_COMPILER /usr/bin/arm-none-eabi-gcc CACHE PATH "" FORCE)
set(CMAKE_CXX_COMPILER /usr/bin/arm-none-eabi-g++ CACHE PATH "" FORCE)

project(freertos_demo C CXX ASM)

set(CMAKE_C_STANDARD 11)
set(CMAKE_CXX_STANDARD 17)

pico_sdk_init()

add_library(FreeRTOS-Config INTERFACE)
target_include_directories(FreeRTOS-Config INTERFACE ${CMAKE_SOURCE_DIR}/config)

add_executable(freertos_demo main.cpp)

target_include_directories(freertos_demo PRIVATE ${CMAKE_CURRENT_LIST_DIR})

target_link_libraries(freertos_demo 
                      pico_stdlib
                      FreeRTOS-Config
                      FreeRTOS-Kernel
                      FreeRTOS-Kernel-Heap4)

pico_add_extra_outputs(freertos_demo)
