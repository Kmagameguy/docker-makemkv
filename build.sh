#!/bin/bash

set -Eeuo pipefail
trap on_error ERR

FFMPEG_VERSION="5.0.1"
FFMPEG_FILENAME="ffmpeg-${FFMPEG_VERSION}"
FFMPEG_URL="https://ffmpeg.org/releases/${FFMPEG_FILENAME}.tar.xz"

MAKEMKV_VERSION="1.16.7"
MAKEMKV_OSS_FILENAME="makemkv-oss-${MAKEMKV_VERSION}"
MAKEMKV_OSS_URL="https://www.makemkv.com./download/${MAKEMKV_OSS_FILENAME}.tar.gz"

MAKEMKV_BIN_FILENAME="makemkv-bin-${MAKEMKV_VERSION}"
MAKEMKV_BIN_URL="https://www.makemkv.com/download/${MAKEMKV_BIN_FILENAME}.tar.gz"

DOCKER_IMAGE_TAG="makemkv-build"

main() {
  cd "$(dirname "$0")" || exit
  build_docker_image
  extract_makemkv_utils
}

on_error() {
  echo "Error on line $(caller): ${BASH_COMMAND}"
}

build_docker_image() {
  docker build -t "$DOCKER_IMAGE_TAG" \
    --build-arg FFMPEG_FILENAME="${FFMPEG_FILENAME}" \
    --build-arg FFMPEG_URL="${FFMPEG_URL}" \
    --build-arg MAKEMKV_OSS_FILENAME="${MAKEMKV_OSS_FILENAME}" \
    --build-arg MAKEMKV_OSS_URL="${MAKEMKV_OSS_URL}" \
    --build-arg MAKEMKV_BIN_FILENAME="${MAKEMKV_BIN_FILENAME}" \
    --build-arg MAKEMKV_BIN_URL="${MAKEMKV_BIN_URL}" \
    "."
}

extract_makemkv_utils() {
  local build_dir="build"
  IMAGE_ID="$(docker create $DOCKER_IMAGE_TAG)"
  mkdir -p "${build_dir}"
  docker cp "$IMAGE_ID:/usr/bin/makemkv" "${build_dir}/"
  docker cp "$IMAGE_ID:/usr/bin/makemkvcon" "${build_dir}/"
  docker rm -v "$IMAGE_ID"
  docker rmi "$DOCKER_IMAGE_TAG"
}

main "${@}"
