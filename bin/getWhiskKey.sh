#!/usr/bin/env bash

JSON_PAYLOAD=$(cat ~/.cf/config.json |jq -rcM '{ "accessToken": (.AccessToken | split(" ")[1]), "refreshToken" : .RefreshToken}')
WSK_NAMESPACE=$(cat ~/.cf/config.json |jq -rcM '[.OrganizationFields.Name, .SpaceFields.Name] | join("_")')

curl -s -X POST -H 'Content-Type: application/json' \
     -d ${JSON_PAYLOAD} ${WSK_APIHOST-https://openwhisk.ng.bluemix.net}/bluemix/v1/authenticate \
     | jq -rcM ".namespaces[] | select(.name | contains(\"${WSK_NAMESPACE}\")) | [.uuid, .key] | join(\":\")"

