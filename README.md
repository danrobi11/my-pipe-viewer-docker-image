# my-pipe-viewer-docker-image
my-pipe-viewer-docker-image

## How to:



```
podman pull ghcr.io/danrobi11/pipe-viewer:latest

mkdir -p ~/pipe-viewer-config

podman run -d --name pipe-viewer --security-opt label=disable --userns=keep-id -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix -v ~/pipe-viewer-config:/home/pipeuser/.config ghcr.io/danrobi11/pipe-viewer:latest
