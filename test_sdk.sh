if [[ -z $1 ]]; then
    echo "Please provide an SDK image you want to test"
fi

docker run -d -it --name pico-sdk --mount type=bind,source=${PWD}/test_poject,target=/home/dev $1
docker exec pico-sdk /bin/sh -c "cd /home/dev && mkdir build && cd build && cmake .. && make -j4"
docker exec pico-sdk /bin/sh -c "picotool"
docker container kill pico-sdk
docker container rm pico-sdk

docker run -d -it --name pico-sdk --mount type=bind,source=${PWD}/freertos_test_project,target=/home/dev $1
docker exec pico-sdk /bin/sh -c "cd /home/dev && mkdir build && cd build && cmake .. && make -j4"
docker exec pico-sdk /bin/sh -c "picotool"
docker container kill pico-sdk
docker container rm pico-sdk
