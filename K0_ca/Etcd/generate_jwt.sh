#!/usr/bin/env bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd $DIR

echo "Etcd JWT key pair"
KEY_PREFIX=jwt
KEY_STORAGE=./CA


openssl genrsa -out $KEY_STORAGE/$KEY_PREFIX.key 2048
openssl rsa -in $KEY_STORAGE/$KEY_PREFIX.key -pubout -out $KEY_STORAGE/$KEY_PREFIX.pub

exit $?
