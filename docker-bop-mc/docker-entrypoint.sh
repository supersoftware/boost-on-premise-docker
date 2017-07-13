#!/bin/sh
set -e

mc config host add $ALIAS $MINIO_URL $RANCHER_ACCESS_KEY $RANCHER_SECRET_KEY $API_SIGNATURE

exec "$@"
