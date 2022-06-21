FROM ubuntu

ARG FFMPEG_FILENAME
ARG FFMPEG_URL

ARG MAKEMKV_OSS_FILENAME
ARG MAKEMKV_OSS_URL

ARG MAKEMKV_BIN_FILENAME
ARG MAKEMKV_BIN_URL

RUN apt update && \ 
    apt install software-properties-common -y

RUN apt-add-repository multiverse -y && \
    apt-add-repository universe -y && \
    apt update && \
    apt install -y \
        build-essential \
        pkg-config \
        libc6-dev \
        libssl-dev \
        libexpat1-dev \
        libavcodec-dev \
        libgl1-mesa-dev \
        libfdk-aac-dev \
        qtbase5-dev \
        zlib1g-dev \
        nasm \
        tar \
        less \
        gcc \
        make \
        curl

WORKDIR /src
RUN curl -LO "${FFMPEG_URL}" && \
    tar -xvf "${FFMPEG_FILENAME}.tar.xz"
WORKDIR /src/${FFMPEG_FILENAME}
RUN ./configure \
    --prefix=/tmp/ffmpeg \
    --enable-static \
    --disable-shared \
    --enable-pic \
    --enable-libfdk-aac
RUN make install

WORKDIR /src
RUN curl -LO "${MAKEMKV_OSS_URL}" && \
    tar -xvf "${MAKEMKV_OSS_FILENAME}.tar.gz"
WORKDIR /src/${MAKEMKV_OSS_FILENAME}
RUN PKG_CONFIG_PATH=/tmp/ffmpeg/lib/pkgconfig ./configure
RUN make && make install

WORKDIR /src
RUN curl -LO "${MAKEMKV_BIN_URL}" && \
    tar -xvf "${MAKEMKV_BIN_FILENAME}.tar.gz"
WORKDIR /src/${MAKEMKV_BIN_FILENAME}
RUN sed '2iexit 0' ./src/ask_eula.sh > tmpfile && mv tmpfile ./src/ask_eula.sh && \
    make && \
    make install

RUN ls -lah /usr/bin
