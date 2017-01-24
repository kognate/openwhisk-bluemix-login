#!/usr/bin/env bash

echo "Logging on to bluemix"

API=`echo $1 | jq --raw-output .api`
export WSK_APIHOST=`echo $1 | jq --raw-output .wsk_apihost`
USER=`echo $1 | jq --raw-output .user`
PASSWORD=`echo $1 | jq --raw-output .password`
ORG=`echo $1 | jq --raw-output .org`
SPACE=`echo $1 | jq --raw-output .space`

if [ "$API" == "null" ]; then
    API=https://api.ng.bluemix.net
fi
if [ "$WSK_APIHOST" == "null" ]; then
    export WSK_APIHOST=https://openwhisk.ng.bluemix.net
fi

#echo "API=$API"
#echo "USER=$USER"
#echo "ORG=$ORG"
#echo "SPACE=$SPACE"

cf login -a $API -u "$USER" -p "$PASSWORD" -o "$ORG" -s "$SPACE"

if [ $? != 0 ]; then
    (>&2 echo "Error logging on")
    exit 1
fi

AUTH=`/action/getWhiskKey.sh`

echo "{ \"auth\": \"${AUTH}\" }"
