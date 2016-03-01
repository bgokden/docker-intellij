#!/bin/bash

if [ -n "$HTTP_PROXY" ]; then
   echo "Acquire::http::Proxy \"$HTTP_PROXY\";" > /etc/apt/apt.conf
fi

if [ -n "$HTTPS_PROXY" ]; then
   echo "Acquire::https::Proxy \"$HTTPS_PROXY\";" >> /etc/apt/apt.conf
fi