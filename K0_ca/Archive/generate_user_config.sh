#!/usr/bin/env bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd $DIR

source ./.requisites

USER=operator
KEY_STORAGE=./usr

cat <<EOF > ./$KEY_STORAGE/$USER.config
apiVersion: v1
clusters:
- cluster:
    certificate-authority-data: $(cat ./CA/ca.crt | openssl enc -A -base64)
    server: https://kubernetes.svc.$K8S_DOMAIN:6443
  name: $K8S_DOMAIN
contexts:
- context:
    cluster: $K8S_DOMAIN
    user: $USER
  name: $K8S_DOMAIN
current-context: $K8S_DOMAIN
kind: Config
preferences: {}
users:
- name: $USER
  user:
    client-certificate-data: $(cat ./$KEY_STORAGE/$USER.crt | openssl enc -A -base64)
    client-key-data: $(cat ./$KEY_STORAGE/$USER.key | openssl enc -A -base64)
EOF

exit $?
