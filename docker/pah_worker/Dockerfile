# Dockerfile that the permuter worker can run agbcc in.

# Build devkitPro
# Adapted from https://github.com/devkitPro/docker to also work on arm host.

FROM debian:buster-slim AS agbcc

ENV DEBIAN_FRONTEND=noninteractive

RUN echo "deb http://deb.debian.org/debian buster-backports main" > /etc/apt/sources.list.d/buster-backports.list && \
    apt-get update && apt-get upgrade -y && \
    apt-get install -y --no-install-recommends apt-utils && \
    apt-get install -y --no-install-recommends sudo ca-certificates pkg-config curl wget bzip2 xz-utils make bsdtar doxygen gnupg && \
    apt-get install -y --no-install-recommends git git-restore-mtime && \
    apt-get install -y --no-install-recommends cmake/buster-backports zip unzip && \
    apt-get install -y --no-install-recommends locales && \
    sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    dpkg-reconfigure --frontend=noninteractive locales && \
    update-locale LANG=en_US.UTF-8 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN wget https://apt.devkitpro.org/install-devkitpro-pacman && \
    chmod +x ./install-devkitpro-pacman && \
    ./install-devkitpro-pacman && \
    rm ./install-devkitpro-pacman && \
    yes | dkp-pacman -Scc

ENV LANG en_US.UTF-8

ENV DEVKITPRO=/opt/devkitpro
ENV PATH=${DEVKITPRO}/tools/bin:$PATH

# dkp-pacman needs /etc/mtab which is not available in the arm version of the debian images.
RUN ((! test -f /etc/mtab) && ln -s /proc/self/mounts /etc/mtab) || true

# TODO what do we really need from the gba-dev package? Just devkitARM itself?
RUN dkp-pacman -Syyu --noconfirm gba-dev &&  \
    yes | dkp-pacman -Scc

ENV DEVKITARM=${DEVKITPRO}/devkitARM


RUN git clone --branch dwarf-bugfix https://github.com/octorock/agbcc.git /agbcc

# Dependencies
RUN apt install -y gcc python3 python3-pip libffi-dev

# Install agbcc
WORKDIR /agbcc
RUN . /etc/profile.d/devkit-env.sh && sh build.sh

ENV PATH="${PATH}:/opt/devkitpro/devkitARM/bin/:/agbcc"

# Install python dependencies for permuter worker.
RUN pip3 install pycparser pynacl toml

WORKDIR /