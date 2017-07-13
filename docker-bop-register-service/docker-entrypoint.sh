#!/bin/sh

while :; do
  len=$(echo $SERVICES | jq length)
  for i in $( seq 0 $(($len - 1)) ); do
    dat=$(echo $SERVICES | jq -r .[$i])
    curl -X PUT -d "$dat" $CONSUL_URL/agent/service/register
  done
  curl -X GET $CONSUL_URL/agent/services | jq .
  sleep 30
done
