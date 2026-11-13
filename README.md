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

Note: If you use a desktop environment. Put a `xhost-local.desktop` file in `~/.config/autostart/`:

```
[Desktop Entry]
Type=Application
Name=Xhost Local
Exec=xhost +SI:localuser:%u
X-GNOME-Autostart-enabled=true
```

### Create the `gtk-pipe-viewer` container:

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
alias uppipe="podman pull ghcr.io/danrobi11/pipe-viewer:latest && podman rm -fi pipe-viewer && podman run -d --name pipe-viewer --security-opt label=disable --userns=keep-id -e DISPLAY=$DISPLAY -e XAUTHORITY=/tmp/.Xauthority -v /tmp/.X11-unix:/tmp/.X11-unix -v $XAUTHORITY:/tmp/.Xauthority:ro -v ~/pipe-viewer-config:/home/pipeuser/.config ghcr.io/danrobi11/pipe-viewer:latest"
```

Then, remove the old image:

```
podman image prune
```

### You can still use the CLI, but you have to override the `entrypoint`.

Note: You don’t need the X11 mounts or xhost for the CLI version.

```
podman run --rm -it --entrypoint pipe-viewer ghcr.io/danrobi11/pipe-viewer:latest
```
