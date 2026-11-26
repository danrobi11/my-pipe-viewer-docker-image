# Unofficial pipe-viewer image

Personal image for [pipe-viewer](https://github.com/trizen/pipe-viewer), published for that community. Written with help from [Grok](https://grok.com).

pipe-viewer is a lightweight YouTube client for Linux. It does not need an API key. Credit to [trizen/pipe-viewer](https://github.com/trizen/pipe-viewer).

## Disclaimer

I use this image for:

- copy and paste
- subscribe
- sync subscriptions

That is the workflow I will fix. Playback with mpv, downloading, and the CLI are not part of what I test. If something else breaks, I will not fix it.

## What this repo does

The Containerfile installs the current `main` branch of pipe-viewer. It is not pinned to an upstream release tag.

GitHub Actions builds `ghcr.io/danrobi11/pipe-viewer:latest` when the Containerfile or the workflow file changes, and when the workflow is run by hand.

The image is Fedora 45. The process user is `pipeuser` (uid 1000). `--userns=keep-id` expects your host user id to be 1000.

## How to

### Pull the image

```
podman pull ghcr.io/danrobi11/pipe-viewer:latest
```

### Create the config directory

```
mkdir -p ~/pipe-viewer-config
```

Mount this directory at `/home/pipeuser/.config`. That is where gtk-pipe-viewer reads `pipe-viewer/gtk-pipe-viewer.conf` and where it writes the thumbnail cache. The cache needs a writable home.

### Allow local X11 access

Add this to the end of `~/.bashrc` (or `~/.bash_profile`):

```
# Allow local X11 access for containers
if [ -n "$DISPLAY" ]; then
  xhost +SI:localuser:$(id -un) >/dev/null 2>&1
fi
```

A desktop session often does not read `~/.bashrc`. For that, put `xhost-local.desktop` in `~/.config/autostart/`:

```
[Desktop Entry]
Type=Application
Name=Xhost Local
Exec=sh -c 'xhost +SI:localuser:"$(id -un)"'
X-GNOME-Autostart-enabled=true
```

The run command also mounts your X authority file. That cookie is for your host name, and the container host name is different, so the grant above is what opens the display.

### How to run and update

Add these aliases to `~/.bash_aliases`. Update with `uppipe` and run with `startpipe`:

```
alias uppipe="podman pull ghcr.io/danrobi11/pipe-viewer:latest"

alias startpipe='podman run -d --rm --name pipe-viewer --security-opt label=disable --userns=keep-id -e DISPLAY="$DISPLAY" -e XAUTHORITY=/tmp/.Xauthority -v /tmp/.X11-unix:/tmp/.X11-unix -v "$XAUTHORITY":/tmp/.Xauthority:ro -v "$HOME/.asoundrc":/etc/asound.conf:ro -v "$HOME/pipe-viewer-config":/home/pipeuser/.config --device /dev/snd ghcr.io/danrobi11/pipe-viewer:latest'
```

Drop unused images. This removes every unused image, not only pipe-viewer:

```
podman image prune
```

## CLI

Not tested. You do not need the X11 mounts or the xhost grant. Override the entrypoint:

```
podman run --rm -it --entrypoint pipe-viewer ghcr.io/danrobi11/pipe-viewer:latest
```
