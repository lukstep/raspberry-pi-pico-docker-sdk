docker build . --tag pico-sdk
docker run -d -it --name pico-sdk --mount type=bind,source=${PWD}/test_poject,target=/home/dev pico-sdk
docker exec pico-sdk /bin/sh -c "cd /home/dev && mkdir build && cd build && cmake .. && make -j4"
docker exec pico-sdk /bin/sh -c "picotool"
