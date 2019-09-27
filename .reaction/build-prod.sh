#!/bin/bash

APP_SOURCE_DIR=${APP_SOURCE_DIR:-/opt/reaction/src}
APP_BUNDLE_DIR=${APP_BUNDLE_DIR:-/opt/reaction/dist}

#export PATH=$PATH:/home/node/.meteor:${APP_SOURCE_DIR}/node_modules/.bin
export PATH=$PATH:${APP_SOURCE_DIR}/node_modules/.bin
export HOME=/home/node
# export NODE_ENV=production

echo "Install Meteor PROD USER: ${USER} NODE_ENV: ${NODE_ENV}"
echo "-----------------------------------------------------------"

cd ${APP_SOURCE_DIR}

#meteor npm install chalk

node --experimental-modules ./.reaction/scripts/build.mjs
echo "[-] Building Meteor application..."
meteor build --server-only --architecture os.linux.x86_64 --directory "${APP_BUNDLE_DIR}"

cd ${APP_BUNDLE_DIR}/bundle/programs/server/

## meteor npm install --save @babel/runtime
## meteor npm install @babel/runtime
meteor npm install --production
