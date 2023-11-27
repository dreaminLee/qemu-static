#!/bin/bash

set -ex

if [ ! -d "qemu"]; then
    git clone https://mirrors.tuna.tsinghua.edu.cn/git/qemu.git
fi

QEMU_REV="8.1.3"
QEMU_GIT_COMMIT=
DOCKER_IMAGE_NAME="build-qemu-static"
HOST_OS_RAW=$(uname -s)
HOST_ARCH_RAW=$(uname -m)
HOST_OS=${HOST_OS_RAW,,}
HOST_ARCH=${HOST_ARCH_RAW,,}

cd qemu
if [ -n "$QEMU_GIT_COMMIT" ]; then
    git checkout -q "$QEMU_GIT_COMMIT"
else
    git checkout -q "v${QEMU_REV}"
fi
cd ..

docker build --tag "$DOCKER_IMAGE_NAME" .

mkdir -p artifact
docker run -it --cidfile="$DOCKER_IMAGE_NAME.cid" "$DOCKER_IMAGE_NAME" true
docker cp "$(cat ${DOCKER_IMAGE_NAME}.cid):work/artifact/." artifact/.
mv "artifact/qemu.tar.xz" "artifact/qemu-${HOST_OS}-${HOST_ARCH}-${QEMU_REV}${QEMU_GIT_COMMIT:+-QEMU_GIT_COMMIT}.tar.xz"
docker container rm "$(cat ${DOCKER_IMAGE_NAME}.cid)"
rm "${DOCKER_IMAGE_NAME}.cid"
docker image rm "${DOCKER_IMAGE_NAME}"

