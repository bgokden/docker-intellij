#!/usr/bin/env bash

echo 'This will take a lot of time...'
BUILDARGS="--build-arg HTTP_PROXY=$HTTP_PROXY --build-arg HTTPS_PROXY=$HTTPS_PROXY --build-arg NO_PROXY=$NO_PROXY --build-arg http_proxy=$http_proxy --build-arg https_proxy=$https_proxy --build-arg no_proxy=$no_proxy"
echo docker build $BUILDARGS -t berkgokden/intellij-dev-scala .
docker build $BUILDARGS -t berkgokden/intellij-dev-scala .
