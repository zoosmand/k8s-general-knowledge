#!/usr/bin/env bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd $DIR

source ../.requisites

COMMENT="Kubernetes Konnectivity Server"
echo $COMMENT

KEY_PREFIX=konnectivity
KEY_STORAGE=./pki

SUBJECT="/O=system:masters/CN=kubernetes-konnectivity"

SUBJECT_FEATURE_01="nsComment=${COMMENT_PREFIX} ${COMMENT}"
SUBJECT_FEATURE_02='basicConstraints=critical,CA:false'
SUBJECT_FEATURE_03='keyUsage=critical,digitalSignature,keyEncipherment,nonRepudiation'
SUBJECT_FEATURE_04='extendedKeyUsage=clientAuth,serverAuth'

mkdir -p $KEY_STORAGE
openssl genrsa -out $KEY_STORAGE/$KEY_PREFIX.key 2048
openssl req -new -key $KEY_STORAGE/$KEY_PREFIX.key -out $KEY_STORAGE/$KEY_PREFIX.csr -subj "${SUBJECT}"
openssl x509 -req -days $(($DAYS*1)) -in $KEY_STORAGE/$KEY_PREFIX.csr -CA ./CA/ca.crt -CAkey ./CA/ca.key -CAcreateserial -sha512 -out $KEY_STORAGE/$KEY_PREFIX.crt \
    -extensions v3_client -extfile <(echo "[v3_client]"; \
        echo "${SUBJECT_FEATURE_01}"; \
        echo "${SUBJECT_FEATURE_02}"; \
        echo "${SUBJECT_FEATURE_03}"; \
        echo "${SUBJECT_FEATURE_04}" \
    )

exit $?
