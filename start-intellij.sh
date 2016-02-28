#!/usr/bin/env bash
RUNENV="-e HTTP_PROXY=$HTTP_PROXY -e HTTPS_PROXY=$HTTPS_PROXY -e http_proxy=$http_proxy -e https_proxy=$https_proxy -e NO_PROXY=$NO_PROXY -e no_proxy=$no_proxy"
docker run -tdi \
           -e DISPLAY=${DISPLAY} \
	   $RUNENV \
           -v /tmp/.X11-unix:/tmp/.X11-unix \
           -v ${HOME}/dockerhome:/home/developer \
           berkgokden/intellij-dev-scala
