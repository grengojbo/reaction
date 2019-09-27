#!/bin/bash

APP_SOURCE_DIR=${APP_SOURCE_DIR:-/opt/reaction/src}
APP_BUNDLE_DIR=${APP_BUNDLE_DIR:-/opt/reaction/dist}

export PATH=$PATH:${APP_SOURCE_DIR}/node_modules/.bin
export HOME=/home/node

echo "RUN: build-dev.sh USER: ${USER} NODE_ENV: ${NODE_ENV}"
