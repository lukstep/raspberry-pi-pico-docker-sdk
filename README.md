# Raspberry Pi Pico Docker SDK

## Run Docker container

```
docker build ./docker --tag pico-sdk

docker run -d -it --name pico-sdk --mount type=bind,source=${PWD},target=/home/dev pico-sdk

docker exec -it pico-sdk /bin/sh
```

## Project build

After attaching to SDK container run the following command to build the project:
```
cd /home/dev

mkdir build

cd build

cmake .. && make -j4

```
