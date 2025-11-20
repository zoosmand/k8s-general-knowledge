#!/usr/bin/env bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd $DIR

source ../.requisites

COMMENT="Kubernetes Etcd API Server Client"
echo $COMMENT

KEY_PREFIX=apiserver-etcd-client
KEY_STORAGE=../Kubernetes/pki

SUBJECT="/O=apiserver-etcd-client/CN=apiserver-etcd-client"

SUBJECT_ALT=$(cat <<-EOL
subjectAltName =
DNS:localhost,
IP:127.0.0.1
EOL
)

SUBJECT_ALT=$(echo $SUBJECT_ALT | sed ':a;N;$!ba;s/\n//g')

SUBJECT_FEATURE_01="nsComment=${COMMENT_PREFIX} ${COMMENT}"
SUBJECT_FEATURE_02='basicConstraints=critical,CA:false'
SUBJECT_FEATURE_03='keyUsage=critical,digitalSignature,keyEncipherment,nonRepudiation'
SUBJECT_FEATURE_04='extendedKeyUsage=clientAuth,serverAuth'

mkdir -p $KEY_STORAGE
openssl genrsa -out $KEY_STORAGE/$KEY_PREFIX.key 2048
openssl req -new -key $KEY_STORAGE/$KEY_PREFIX.key -out $KEY_STORAGE/$KEY_PREFIX.csr -subj "${SUBJECT}" -addext "${SUBJECT_ALT}"
openssl x509 -req -days $(($DAYS*1)) -in $KEY_STORAGE/$KEY_PREFIX.csr -CA ./CA/ca.crt -CAkey ./CA/ca.key -CAcreateserial -sha512 -out $KEY_STORAGE/$KEY_PREFIX.crt \
    -extensions v3_srv -extfile <(echo "[v3_srv]"; \
        echo "${SUBJECT_FEATURE_01}"; \
        echo "${SUBJECT_FEATURE_02}"; \
        echo "${SUBJECT_FEATURE_03}"; \
        echo "${SUBJECT_FEATURE_04}"; \
        echo "${SUBJECT_ALT}" \
    )

exit $?
