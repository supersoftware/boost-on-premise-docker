#!/bin/sh

if [[ -z "${REGISTRATION_TOKEN}" ]]; then
  echo "skip registration process\n"
else
  ### get service id
  container=$(curl -u "$RANCHER_ACCESS_KEY:$RANCHER_SECRET_KEY" \
  -X GET \
  $RANCHER_URL/services | \
  jq -r --arg name $SERVICE_NAME '.data[] | if .name == $name then .id else empty end')

  ### get ca certificate
  cert=$(curl -u "$RANCHER_ACCESS_KEY:$RANCHER_SECRET_KEY" \
  -X GET \
  $RANCHER_URL/certificates | \
  jq --arg name $CERT_NAME '.data[] | if .name == $name then .certChain else empty end')

  ### place ca certificate
  rancher exec $container /bin/sh -c "echo $cert > /usr/local/share/ca-certificates/on-premise.crt"

  ### update ca certificate
  rancher exec $container update-ca-certificates

  ### register runner
  # https://gitlab.com/gitlab-org/gitlab-ci-multi-runner/blob/master/docs/commands/README.md#configuration-file
  rancher exec $container gitlab-ci-multi-runner register \
    --non-interactive \
    --name $SERVICE_NAME \
    --url $GITLAB_URL \
    --registration-token $REGISTRATION_TOKEN \
    --executor $EXCUTOR \
    --docker-image $DOCKER_IMAGE \
    --docker-volumes $DOCKER_VOLUMES \
    --docker-dns $DOCKER_DNS \
    --docker-dns 169.254.169.250
fi
