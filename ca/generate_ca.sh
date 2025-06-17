#!/usr/bin/env bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd $DIR

CA_PART='01'
CA_PREFIX='/C=CY/ST=Cyprus/L=Limassol/O=Askug Ltd./OU=Certificate Authority Center-01'
DAYS=365
BASE_DOMAIN='askug.net'

# --- Generate Root CA Certificate --- #
echo "Root CA"
SUBJECT_ROOT="$CA_PREFIX/CN=root-$CA_PART.ca.$BASE_DOMAIN"

SUBJECT_FEATURE_01="nsComment=Askug Ltd. CA Root Certificate \#$CA_PART"
SUBJECT_FEATURE_02='basicConstraints=critical,CA:true'
SUBJECT_FEATURE_03='keyUsage=critical,keyCertSign,cRLSign'

openssl genrsa -out ca.key 2048
openssl req -days $(($DAYS*10)) -new -x509 -sha512 -key ca.key -out ca.crt -subj "$SUBJECT_ROOT" \
    -extensions v3_ca -config <(echo "[v3_ca]"; \
        echo "$SUBJECT_FEATURE_01"; \
        echo "$SUBJECT_FEATURE_02"; \
        echo "$SUBJECT_FEATURE_03" \
        )

exit $?
