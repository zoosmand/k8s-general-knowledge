#!/usr/bin/env bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd $DIR

source ./.requisites

K8S_SRV_PREFIX="$K8S_SRV_PREFIX/OU=Kubernetes Cluster Certificate Authority"

# --- Generate K0s CA --- #
echo "K0s CA"
KEY_PREFIX=ca
KEY_STORAGE=./CA
SUBJECT_K0S_CA="$K8S_SRV_PREFIX/CN=$KEY_PREFIX.$K8S_DOMAIN"

SUBJECT_FEATURE_01="nsComment=Askug Ltd. Kubernetes k0s Certificate Authority"
SUBJECT_FEATURE_02='basicConstraints=critical,CA:true'
SUBJECT_FEATURE_03='keyUsage=critical,keyCertSign,cRLSign'

mkdir -p $KEY_STORAGE
openssl genrsa -out $KEY_STORAGE/$KEY_PREFIX.key 2048
openssl req -new -key $KEY_STORAGE/$KEY_PREFIX.key -out $KEY_STORAGE/$KEY_PREFIX.csr -subj "$SUBJECT_K0S_CA"
openssl x509 -req -days $(($DAYS*5)) -in $KEY_STORAGE/$KEY_PREFIX.csr -CA ../ca/ca.crt -CAkey ../ca/ca.key -CAcreateserial -sha512 -out $KEY_STORAGE/$KEY_PREFIX.crt \
    -extensions v3_srv -extfile <(echo "[v3_srv]"; \
        echo "$SUBJECT_FEATURE_01"; \
        echo "$SUBJECT_FEATURE_02"; \
        echo "$SUBJECT_FEATURE_03" \
        )

exit $?
