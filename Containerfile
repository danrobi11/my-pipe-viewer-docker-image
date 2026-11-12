FROM fedora:45

RUN dnf install -y --setopt=install_weak_deps=False \
    perl \
    perl-App-cpanminus \
    perl-JSON \
    perl-LWP-Protocol-https \
    perl-Term-ReadLine-Gnu \
    perl-Gtk3 \
    perl-Cairo \
    perl-Glib \
    gtk3 \
    mpv \
    yt-dlp \
    deno \
    wget unzip make gcc \
    libX11 libXext libXcursor libXi libXrandr && \
    dnf clean all

# Create non-root user
RUN useradd -m -u 1000 pipeuser && \
    mkdir -p /home/pipeuser/.config && \
    chown -R pipeuser:pipeuser /home/pipeuser

# Build and install pipe-viewer with GTK
RUN wget -O /tmp/pipe-viewer.zip https://github.com/trizen/pipe-viewer/archive/refs/heads/main.zip && \
    unzip /tmp/pipe-viewer.zip -d /tmp && \
    cd /tmp/pipe-viewer-main && \
    perl Build.PL --gtk && \
    ./Build && \
    ./Build install && \
    rm -rf /tmp/pipe-viewer*

USER pipeuser
WORKDIR /home/pipeuser
ENTRYPOINT ["gtk-pipe-viewer"]
