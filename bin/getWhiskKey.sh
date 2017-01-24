#!/usr/bin/env bash

ACCESS_TOKEN=`cat ~/.cf/config.json | jq --raw-output .AccessToken | awk '{print $2}'`
REFRESH_TOKEN=`cat ~/.cf/config.json | jq --raw-output .RefreshToken`

WSK_CREDENTIALS=`curl -s -X POST -H 'Content-Type: application/json' -d "{\"accessToken\": \"${ACCESS_TOKEN}\", \"refreshToken\": \"${REFRESH_TOKEN}\"}" ${WSK_APIHOST-https://openwhisk.ng.bluemix.net}/bluemix/v1/authenticate`

CF_ORG=`cat ~/.cf/config.json | jq --raw-output .OrganizationFields.Name`
CF_SPACE=`cat ~/.cf/config.json | jq --raw-output .SpaceFields.Name`

WSK_NAMESPACE="${CF_ORG}_${CF_SPACE}"

S=`echo "${WSK_CREDENTIALS}" | jq ".namespaces[] | select(.name | contains(\"${WSK_NAMESPACE}\"))"`

UUID=`echo $S | jq --raw-output .uuid`
KEY=`echo $S | jq --raw-output .key`

echo "${UUID}:${KEY}"
