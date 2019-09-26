#!/bin/bash

APP_SOURCE_DIR=${APP_SOURCE_DIR:-/opt/reaction/src}
APP_BUNDLE_DIR=${APP_BUNDLE_DIR:-/opt/reaction/dist}

export PATH=$PATH:/home/node/.meteor:${APP_SOURCE_DIR}/node_modules/.bin
export HOME=/home/node
export NODE_ENV=development

echo "USER: ${USER} NODE_ENV: ${NODE_ENV}"

cd /opt/reaction/src/

meteor npm install