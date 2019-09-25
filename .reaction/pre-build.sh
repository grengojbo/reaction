#!/bin/bash
export PATH=$PATH:/home/node/.meteor
export HOME=/home/node
echo "USER: $USER Meteor: $1"
/opt/reaction/src/.reaction/test-script.sh $1