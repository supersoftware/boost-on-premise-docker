#!/bin/sh

jo -p \
serverAddress=$REGISTRY_DOMAIN \
> data.json

id=$(curl -u "$RANCHER_ACCESS_KEY:$RANCHER_SECRET_KEY" \
-X POST \
-H "Content-Type: application/json" \
-d @data.json \
$RANCHER_URL/registries | jq '.id')

jo -p \
registryId=$id \
email=$REGISTRY_USER@$REGISTRY_DOMAIN \
publicValue=$REGISTRY_USER \
secretValue=$REGISTRY_PASS \
> data.json

curl -u "$RANCHER_ACCESS_KEY:$RANCHER_SECRET_KEY" \
-X POST \
-H "Content-Type: application/json" \
-d @data.json \
$RANCHER_URL/registryCredentials | jq .

rm -rf data.json
