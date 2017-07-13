#!/bin/sh

jo -p \
name=$CERT_NAME \
key="`awk 'NF {sub(/\r/, ""); printf "%s\\n",$0;}' $SSL_KEY_PATH`" \
cert="`awk 'NF {sub(/\r/, ""); printf "%s\\n",$0;}' $SSL_CERT_PATH`" \
certChain="`awk 'NF {sub(/\r/, ""); printf "%s\\n",$0;}' $CA_CERT_PATH`" \
> data.json

curl -u "$RANCHER_ACCESS_KEY:$RANCHER_SECRET_KEY" \
-X POST \
-H "Content-Type: application/json" \
-d @data.json \
$RANCHER_URL/certificates | jq '.state'

rm -rf data.json $SSL_KEY_PATH $SSL_CERT_PATH
