#!/bin/bash

APP_SOURCE_DIR=${APP_SOURCE_DIR:-/opt/reaction/src}
APP_BUNDLE_DIR=${APP_BUNDLE_DIR:-/opt/reaction/dist}

#export PATH=$PATH:/home/node/.meteor:${APP_SOURCE_DIR}/node_modules/.bin
export PATH=$PATH:${APP_SOURCE_DIR}/node_modules/.bin
export HOME=/home/node
# export NODE_ENV=development

echo "Install Meteor package USER: ${USER} NODE_ENV: ${NODE_ENV}"
echo "-----------------------------------------------------------"

cd ${APP_SOURCE_DIR}

meteor npm install