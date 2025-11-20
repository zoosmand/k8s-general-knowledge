#!/usr/bin/env bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd $DIR

source ../.requisites

COMMENT="Kubernetes API Server"
echo $COMMENT

KEY_PREFIX=k0s-api
KEY_STORAGE=./pki

SUBJECT="/O=kubernetes/CN=k0s-api"

SUBJECT_FEATURE_01="nsComment=${COMMENT_PREFIX} ${COMMENT}"
SUBJECT_FEATURE_02='basicConstraints=critical,CA:false'
SUBJECT_FEATURE_03='keyUsage=critical,digitalSignature,keyEncipherment,nonRepudiation'
SUBJECT_FEATURE_04='extendedKeyUsage=clientAuth,serverAuth'

SUBJECT_ALT=$(cat <<-EOL
subjectAltName =
DNS:kubernetes,
DNS:kubernetes.default,
DNS:kubernetes.default.svc,
DNS:kubernetes.default.svc.cluster,
DNS:kubernetes.svc.$K8S_DOMAIN,
DNS:localhost,
IP:127.0.0.1,
IP:127.0.1.1,
IP:192.168.203.10,
IP:192.168.203.191,
IP:192.168.203.192,
IP:10.96.0.1
EOL
)
SUBJECT_ALT=$(echo $SUBJECT_ALT | sed ':a;N;$!ba;s/\n//g')


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
