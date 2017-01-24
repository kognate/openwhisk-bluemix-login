#!/usr/bin/env bash

DOCKER_USER="$1"
if [ -z "${DOCKER_USER}" ]; then
    echo -n "Docker User: "
    read DOCKER_USER
fi
docker login -u "$DOCKER_USER"

IMAGE_NAME=openwhisk-bluemix-login
IMAGE="${DOCKER_USER}/${IMAGE_NAME}"

echo "Building ${IMAGE} for ${DOCKER_USER}"

wsk package update bluemix

docker build -t "${IMAGE}" . \
    && docker push "${IMAGE}" \
    && wsk action update \
	   --docker bluemix/login \
	   "${IMAGE}" \
	   -a web-export true
