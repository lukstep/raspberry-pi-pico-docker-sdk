#! /usr/bin/env bash

RED="\e[31m"
GREEN="\e[32m"
NC="\e[0m"
STATUS=0

if [[ -z $1 ]]; then
    echo "Please provide an SDK image you want to test"
fi

declare -a boards=("pico" "pico_w" "pico2" "pico2_riscv" "pico2_w" "pico2_w_riscv")


docker run -d -it --name pico-sdk --mount type=bind,source="${PWD}"/test_poject,target=/home/dev "$1"

for board in "${boards[@]}"
do
    echo "---- $board build test ----"
    docker exec pico-sdk /bin/bash -c "rm -rf /home/dev/build"
    if [[ $board = pico2_riscv ]] ; then
        docker exec -i pico-sdk /bin/bash -c "cd /home/dev && mkdir build && cd build && cmake .. -DPICO_BOARD=pico2 -DPICO_PLATFORM=rp2350-riscv && make -j4"
    elif [[ $board = pico2_w_riscv ]] ; then
        docker exec -i pico-sdk /bin/bash -c "cd /home/dev && mkdir build && cd build && cmake .. -DPICO_BOARD=pico2_w -DPICO_PLATFORM=rp2350-riscv && make -j4"
    else
        docker exec -i pico-sdk /bin/bash -c "cd /home/dev && mkdir build && cd build && cmake .. -DPICO_BOARD=${board} && make -j4"
    fi
    if [ $? != 0 ]; then
        echo -e "${RED}----- Test failed -----${NC}"
        STATUS=1
        break
    fi
    echo "${GREEN}----- Test passed -----${NC}"
done

docker container kill pico-sdk
docker container rm pico-sdk

exit ${STATUS}

# for board in "${boards[@]}"
# do
#     echo "FreeRTOS $board build test"
#     docker run -d -it --name pico-sdk --mount type=bind,source=${PWD}/freertos_test_project,target=/home/dev $1
#     if [[ $board -eq "pico2_riscv" ]] ; then
#         docker exec pico-sdk /bin/bash -c "cd /home/dev && mkdir build && cd build && cmake .. -DPICO_BOARD=pico2 -DPICO_PLATFORM=rp2350-riscv && make -j4"
#     else
#         docker exec pico-sdk /bin/bash -c "cd /home/dev && mkdir build && cd build && cmake .. -DPICO_BOARD=${board} && make -j4 && cd .. && rm -rf build"
#     fi
#     docker exec pico-sdk /bin/bash -c "rm -rf /home/dev/build"
#     docker container kill pico-sdk
#     docker container rm pico-sdk
#     rm -rf ./test_poject/build/
# done

