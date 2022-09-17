# Raspberry Pi Pico Docker

## Run Docker container

```
docker build ./docker --tag pico-sdk

docker run -d -it --name pico-sdk --mount type=bind,source=${PWD},target=/home/dev pico-sdk

docker exec -it pico-sdk /bin/sh
```
