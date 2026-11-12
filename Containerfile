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

# Create a non-root user (UID will be remapped by --userns=keep-id)
RUN useradd -m -u 1000 pipeuser && \
    mkdir -p /home/pipeuser/.config && \
    chown -R pipeuser:pipeuser /home/pipeuser

RUN wget -O /tmp/pipe-viewer.zip https://github.com/trizen/pipe-viewer/archive/refs/heads/main.zip && \
    unzip /tmp/pipe-viewer.zip -d /tmp && \
    cd /tmp/pipe-viewer-main && \
    perl Build.PL && \
    ./Build && \
    ./Build install && \
    rm -rf /tmp/pipe-viewer*

USER pipeuser
WORKDIR /home/pipeuser
ENTRYPOINT ["pipe-viewer"]
