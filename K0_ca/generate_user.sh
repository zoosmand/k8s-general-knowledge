#!/usr/bin/env bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd $DIR

source ./.requisites

K8S_USR_PREFIX="$K8S_USR_PREFIX/OU=Certificate Authority"
USER=operator
GROUP="system:operators"

# --- Generate K0s CA --- #
echo "K0s $USER"
KEY_PREFIX=$USER
KEY_STORAGE=./usr
SUBJECT_K0S_USR="/O=$GROUP/CN=$USER"

SUBJECT_FEATURE_01="nsComment=Issued by Askug Ltd. Kubernetes k0s Certificate Authority"
SUBJECT_FEATURE_02='basicConstraints=critical,CA:false'
SUBJECT_FEATURE_03='keyUsage=critical,digitalSignature,keyEncipherment,nonRepudiation'
SUBJECT_FEATURE_04='extendedKeyUsage=clientAuth'

mkdir -p $KEY_STORAGE
openssl genrsa -out $KEY_STORAGE/$KEY_PREFIX.key 2048
openssl req -new -key $KEY_STORAGE/$KEY_PREFIX.key -out $KEY_STORAGE/$KEY_PREFIX.csr -subj "$SUBJECT_K0S_USR"
openssl x509 -req -days $(($DAYS*2)) -in $KEY_STORAGE/$KEY_PREFIX.csr -CA ./CA/ca.crt -CAkey ./CA/ca.key -CAcreateserial -sha512 -out $KEY_STORAGE/$KEY_PREFIX.crt \
    -extensions v3_srv -extfile <(echo "[v3_srv]"; \
        echo "$SUBJECT_FEATURE_01"; \
        echo "$SUBJECT_FEATURE_02"; \
        echo "$SUBJECT_FEATURE_03"; \
        echo "$SUBJECT_FEATURE_04" \
        )

exit $?
