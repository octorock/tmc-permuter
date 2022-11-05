# Dockerfile for the permuter with the tmc repo.


# Build devkitPro
# Adapted from https://github.com/devkitPro/docker to also work on arm host.

# IMAGE toolchain-base: Base image for devkitPro.
FROM debian:buster-slim AS toolchain-base

ENV DEBIAN_FRONTEND=noninteractive

# dkp-pacman needs /etc/mtab which is not available in the arm version of the debian images.
RUN ((! test /etc/mtab) && ln -s /proc/self/mounts /etc/mtab) || true
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


# IMAGE devkitarm: Install gba tools.
FROM toolchain-base AS devkitarm

RUN ln -s /proc/self/mounts /etc/mtab
#RUN cat /etc/mtab
RUN dkp-pacman -Syyu --noconfirm gba-dev &&  \
    yes | dkp-pacman -Scc

ENV DEVKITARM=${DEVKITPRO}/devkitARM

# Fetch repo and install packages that are not changed often.
FROM devkitarm AS data-base

RUN git clone --branch dwarf-bugfix https://github.com/octorock/agbcc.git /agbcc

# Dependencies
RUN apt install -y gcc python3 python3-pip libffi-dev libpng-dev

# IMAGE agbcc: Install agbcc.
FROM data-base AS agbcc

# Install agbcc
WORKDIR /agbcc
RUN . /etc/profile.d/devkit-env.sh && sh build.sh
RUN sh install.sh /repo


# IMAGE permuter: Install permuter and dependencies.
FROM agbcc AS permuter
RUN git clone https://github.com/simonlindholm/decomp-permuter.git /permuter
RUN pip3 install pycparser pynacl toml


# IMAGE tmc-permuter: Permuter on the tmc repo
FROM permuter as tmc-permuter
RUN git clone https://github.com/zeldaret/tmc /repo

# Setup tmc repo
WORKDIR /repo
RUN make setup
WORKDIR /agbcc
RUN sh install.sh /repo

ENV PATH="${PATH}:/opt/devkitpro/devkitARM/bin/:/agbcc"

#ADD ./example /permuter/example
ADD ./permute.sh /permuter

WORKDIR /permuter

CMD ./permute.sh