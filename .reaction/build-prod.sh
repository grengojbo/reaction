#!/bin/bash

APP_SOURCE_DIR=${APP_SOURCE_DIR:-/opt/reaction/src}
APP_BUNDLE_DIR=${APP_BUNDLE_DIR:-/opt/reaction/dist}

export PATH=$PATH:/home/node/.meteor:${APP_SOURCE_DIR}/node_modules/.bin
export HOME=/home/node
export NODE_ENV=production
echo "USER: ${USER} NODE_ENV: ${NODE_ENV}"

cd ${APP_SOURCE_DIR}

node --experimental-modules ./.reaction/scripts/build.mjs
echo "[-] Building Meteor application..."
meteor build --server-only --architecture os.linux.x86_64 --directory "${APP_BUNDLE_DIR}"

cd ${APP_BUNDLE_DIR}/bundle/programs/server/

meteor npm install --production