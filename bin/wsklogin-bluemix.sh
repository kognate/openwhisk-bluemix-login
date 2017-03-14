#!/usr/bin/env bash
# -*- mode: Bash

while getopts "u:p:s:o:" opt; do
  case $opt in
    u)
      BLUEMIX_USER="$OPTARG"
      ;;
    p)
      BLUEMIX_PASSWORD="$OPTARG"
      ;;
    o)
      BLUEMIX_ORG="$OPTARG"
      ;;
    s)
      BLUEMIX_SPACE="$OPTARG"
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      ;;
  esac
done

if [ -z "$BLUEMIX_USER" ]; then
    echo -n "User: "
    read BLUEMIX_USER
fi

if [ -z "$BLUEMIX_PASSWORD" ]; then
   echo -n "Password: "
   read -s BLUEMIX_PASSWORD
   echo
fi

if [ -z "$BLUEMIX_ORG" ]; then
    echo -n "Org: "
    read BLUEMIX_ORG
fi

if [ -z "$BLUEMIX_SPACE" ]; then
    echo -n "Space: "
    read BLUEMIX_SPACE
fi

LOGIN_URL=$(curl -s ${CF_API_HOST-https://api.ng.bluemix.net}/info |jq -rcM '[.authorization_endpoint, "oauth/token"] | join("/") ')

JSON_PAYLOAD=$(curl -s -X "POST" $LOGIN_URL \
     -H "Accept: application/json;charset=utf-8" \
     -H "Content-Type: application/x-www-form-urlencoded; charset=utf-8" \
     -u cf: \
     --data-urlencode "grant_type=password" \
     --data-urlencode "username=${BLUEMIX_USER}" \
     --data-urlencode "password=${BLUEMIX_PASSWORD}" \
     | jq -rcM '{ "accessToken": .access_token, "refreshToken" : .refresh_token}')


WSK_NAMESPACE="${BLUEMIX_ORG}_${BLUEMIX_SPACE}"

curl -s -X POST -H 'Content-Type: application/json' \
     -d ${JSON_PAYLOAD} ${WSK_APIHOST-https://openwhisk.ng.bluemix.net}/bluemix/v1/authenticate \
     | jq -rcM ".namespaces[] | select(.name | contains(\"${WSK_NAMESPACE}\")) | [.uuid, .key] | join(\":\")"
