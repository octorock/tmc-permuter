FROM debian:bullseye-slim AS agbcc-builder

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y binutils-arm-none-eabi && \
    apt-get install -y gcc git ca-certificates make && \
    apt-get clean

RUN git clone --branch dwarf-bugfix https://github.com/octorock/agbcc.git /agbcc
WORKDIR /agbcc
RUN ./build.sh && mkdir /agbcc-install && ./install.sh /agbcc-install


FROM debian:bullseye-slim

COPY --from=agbcc-builder /agbcc-install/tools/agbcc /agbcc

ENV PATH="${PATH}:/agbcc/bin"

RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y --no-install-recommends \
    binutils-arm-none-eabi \
    python3 \
    python3-pip \
    libffi-dev \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN pip3 install pynacl toml && pip3 cache purge
