#!/usr/bin/env bash

if test $# -ne 1; then
  echo "usage: $0 <kubernetes_user>";
  exit 1
fi
USER_NAME=$1

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd $DIR

source ./.requisites

KEY_STORAGE=./usr

cat <<EOF > ./$KEY_STORAGE/$USER_NAME.config
apiVersion: v1
clusters:
- cluster:
    certificate-authority-data: $(cat ./Kubernetes/CA/ca.crt | openssl enc -A -base64)
    server: https://kubernetes.svc.$K8S_DOMAIN:6443
  name: $K8S_DOMAIN
contexts:
- context:
    cluster: $K8S_DOMAIN
    user: $USER_NAME
  name: $K8S_DOMAIN
current-context: $K8S_DOMAIN
kind: Config
preferences: {}
users:
- name: $USER_NAME
  user:
    client-certificate-data: $(cat ./$KEY_STORAGE/$USER_NAME.crt | openssl enc -A -base64)
    client-key-data: $(cat ./$KEY_STORAGE/$USER_NAME.key | openssl enc -A -base64)
EOF

exit $?