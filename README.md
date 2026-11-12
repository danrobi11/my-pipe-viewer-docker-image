# Unofficial pipe-viewer docker image

Credit to: https://github.com/trizen/pipe-viewer

A lightweight YouTube client for Linux, without requiring an API key.

## How to:

### Pull the image:

```
podman pull ghcr.io/danrobi11/pipe-viewer:latest
```

### Create the `pipe-viewer-config` directory:

```
mkdir -p ~/pipe-viewer-config
```

### Add this to the end of `~/.bashrc` (or ~/.bash_profile):

```
# Allow local X11 access for containers
if [ -n "$DISPLAY" ]; then
  xhost +SI:localuser:$(id -un) >/dev/null 2>&1
fi
```

### Create the pipe-viewer container:

```
podman run -d --name pipe-viewer --security-opt label=disable --userns=keep-id -e DISPLAY=$DISPLAY -e XAUTHORITY=/tmp/.Xauthority -v /tmp/.X11-unix:/tmp/.X11-unix -v $XAUTHORITY:/tmp/.Xauthority:ro -v ~/pipe-viewer-config:/home/pipeuser/.config ghcr.io/danrobi11/pipe-viewer:latest
```

### Manage container:

```
podman start pipe-viewer
podman stop pipe-viewer
```
Note: When you close/quit `pipe-viewer` the container should stop. Otherwise: `podman stop pipe-viewer`

### How to Update:

Add this alias in `~/.bash_aliases`.
Run an update with: `uppipe`

```
alias uppipe="podman pull ghcr.io/danrobi11/pipe-viewer:latest && podman stop pipe-viewer && podman rm pipe-viewer && podman run -d --name pipe-viewer --security-opt label=disable --userns=keep-id -e DISPLAY=$DISPLAY -e XAUTHORITY=/tmp/.Xauthority -v /tmp/.X11-unix:/tmp/.X11-unix -v $XAUTHORITY:/tmp/.Xauthority:ro -v ~/pipe-viewer-config:/home/pipeuser/.config ghcr.io/danrobi11/pipe-viewer:latest"
```

Then, remove the old image:

```
podman image prune
```
