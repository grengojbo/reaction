#!/bin/bash

APP_SOURCE_DIR=${APP_SOURCE_DIR:-/opt/reaction/src}
APP_BUNDLE_DIR=${APP_BUNDLE_DIR:-/opt/reaction/dist}

export PATH=$PATH:/home/node/.meteor:${APP_SOURCE_DIR}/node_modules/.bin
export HOME=/home/node

# export NODE_ENV=production
echo "USER: ${USER} NODE_ENV: ${NODE_ENV}"

cd ${APP_SOURCE_DIR}

# meteor npm install @babel/runtime simpl-schema react lodash imports \
#  accounting-js i18next @reactioncommerce/reaction-error react-router-dom \
#  react-router history path-to-regexp query-parse immutable \
#  @reactioncommerce/reaction-components @reactioncommerce/logger \
#  meteor-node-stubs transliteration slugify @reactioncommerce/file-collections \
#  prop-types moment moment-timezone store @reactioncommerce/random \
#  i18next-browser-languagedetector i18next-sprintf-postprocessor \
#  i18next-fetch-backend i18next-multiload-backend-adapter jquery-i18next \
#  @reactioncommerce/schemas @reactioncommerce/reaction-router 

meteor npm install
meteor npm install chalk

node --experimental-modules ./.reaction/scripts/build.mjs
echo "[-] Building Meteor application..."
meteor build --server-only --architecture os.linux.x86_64 --directory "${APP_BUNDLE_DIR}"

cd ${APP_BUNDLE_DIR}/bundle/programs/server/

# meteor npm install --save @babel/runtime
# meteor npm install @babel/runtime
meteor npm install --production

# meteor npm install --save @babel/runtime react lodash imports accounting-js
# │ │ │ meteor-artifact/setup  i18next @reactioncommerce/reaction-error react-router-dom react-router history
# │ │ │ meteor-artifact/setup  path-to-regexp query-parse immutable @reactioncommerce/reaction-components
# │ │ │ meteor-artifact/setup  @reactioncommerce/logger @reactioncommerce/random transliteration