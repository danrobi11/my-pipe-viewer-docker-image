FROM fedora:45

RUN dnf install -y --setopt=install_weak_deps=False \
    perl \
    perl-App-cpanminus \
    perl-JSON \
    perl-LWP-Protocol-https \
    perl-Term-ReadLine-Gnu \
    mpv \
    yt-dlp \
    wget unzip make gcc && \
    dnf clean all

# Build and install pipe-viewer (CLI only)
RUN wget -O /tmp/pipe-viewer.zip https://github.com/trizen/pipe-viewer/archive/refs/heads/main.zip && \
    unzip /tmp/pipe-viewer.zip -d /tmp && \
    cd /tmp/pipe-viewer-main && \
    perl Build.PL && \
    ./Build && \
    ./Build install && \
    rm -rf /tmp/pipe-viewer*

ENTRYPOINT ["pipe-viewer"]
