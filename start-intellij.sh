#!/usr/bin/env bash
RUNENV="-e HTTP_PROXY=$HTTP_PROXY -e HTTPS_PROXY=$HTTPS_PROXY -e http_proxy=$http_proxy -e https_proxy=$https_proxy -e NO_PROXY=$NO_PROXY -e no_proxy=$no_proxy"
docker run -tdi \
           -e DISPLAY=${DISPLAY} \
	   $RUNENV \
	   --net=host \
	   -v /var/run/docker.sock:/var/run/docker.sock \
           -v /tmp/.X11-unix:/tmp/.X11-unix \
           -v /home/developer:/home/developer \
           berkgokden/intellij-dev-scala
