#!/usr/bin/env bash

# -v /tmp/.X11-unix:/tmp/.X11-unix \
ip=$(ifconfig en0 | grep inet | awk '$1=="inet" {print $2}')

xhost +"$ip"

docker run \
  -v "$HOME"/.ssh/:/home/dev/.ssh:ro -v /var/run/docker.sock:/var/run/docker.sock \
  -v "$PWD"/:/home/dev/host \
  -v /etc/localtime:/etc/localtime:ro \
  -e DISPLAY="$ip:0" \
  -e LANG="C.UTF-8" \
  -e LC_ALL="C.UTF-8" \
  -it \
  --rm \
  devimage

xhost -
