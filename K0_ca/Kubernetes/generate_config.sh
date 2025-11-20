#!/usr/bin/env bash

if test $# -ne 1; then
  echo "usage: $0 <kubernetes_user>";
  exit 1
fi
K0S_USER=$1

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd $DIR

source ../.requisites

KEY_STORAGE=./pki

cat <<EOF > ./$KEY_STORAGE/$K0S_USER.conf
apiVersion: v1
clusters:
- cluster:
    certificate-authority-data: $(cat ./CA/ca.crt | openssl enc -A -base64)
    server: https://localhost:6443
  name: local
contexts:
- context:
    cluster: local
    user: user
  name: Default
current-context: Default
kind: Config
preferences: {}
users:
- name: user
  user:
    client-certificate-data: $(cat ./$KEY_STORAGE/$K0S_USER.crt | openssl enc -A -base64)
    client-key-data: $(cat ./$KEY_STORAGE/$K0S_USER.key | openssl enc -A -base64)
EOF

exit $?