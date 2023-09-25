#!/bin/bash

docker run --rm -d -it --name pico-sdk --network=host --mount type=bind,source=${PWD},target=/home/dev pico-sdk-debug

session="Pico-sdk"

tmux new-session -d -s $session

window=0
tmux rename-window -t $session:$window 'Docker' 
tmux send-keys -t $session:$window 'docker exec -it pico-sdk ./bin/sh' C-m

window=1
tmux new-window -t $session:$window -n 'OpenOCD'
tmux send-keys -t $session:$window 'sudo openocd -f interface/cmsis-dap.cfg -f target/rp2040.cfg -c "bindto 0.0.0.0"' C-m

window=2
tmux new-window -t $session:$window -n 'UART'

tmux attach-session -t $session
