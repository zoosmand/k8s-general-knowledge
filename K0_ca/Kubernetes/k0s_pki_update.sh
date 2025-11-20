#!/usr/bin/env bash

K0S_ARCH=k0s_pki_2025-11-17_01.tgz
ETCD_ARCH=etcd_pki_2025-11-16_03.tgz

tar xzvf ./${K0S_ARCH}

cp ./pki/admin.conf /var/lib/k0s/pki/
cp ./pki/admin.crt /var/lib/k0s/pki/
cp ./pki/admin.key /var/lib/k0s/pki/

cp ./pki/apiserver-etcd-client.crt /var/lib/k0s/pki/
cp ./pki/apiserver-etcd-client.key /var/lib/k0s/pki/

cp ./pki/apiserver-kubelet-client.crt /var/lib/k0s/pki/
cp ./pki/apiserver-kubelet-client.key /var/lib/k0s/pki/

cp ./pki/ccm.conf /var/lib/k0s/pki/
cp ./pki/ccm.crt /var/lib/k0s/pki/
cp ./pki/ccm.key /var/lib/k0s/pki/

cp ./pki/k0s-api.crt /var/lib/k0s/pki/
cp ./pki/k0s-api.key /var/lib/k0s/pki/

cp ./pki/konnectivity.conf /var/lib/k0s/pki/
cp ./pki/konnectivity.crt /var/lib/k0s/pki/
cp ./pki/konnectivity.key /var/lib/k0s/pki/
cp ./pki/scheduler.conf /var/lib/k0s/pki/
cp ./pki/scheduler.crt /var/lib/k0s/pki/
cp ./pki/scheduler.key /var/lib/k0s/pki/

cp ./pki/server.crt /var/lib/k0s/pki/
cp ./pki/server.key /var/lib/k0s/pki/

rm -r ./pki/

#tar xzvf ./${ETCD_ARCH}

#cp ./pki/server.key /var/lib/k0s/pki/etcd/
#cp ./pki/server.crt /var/lib/k0s/pki/etcd/

#cp ./pki/peer.key /var/lib/k0s/pki/etcd/
#cp ./pki/peer.crt /var/lib/k0s/pki/etcd/

#chown kube-scheduler /var/lib/k0s/pki/scheduler*
#chown kube-apiserver /var/lib/k0s/pki/server*
#chown kube-apiserver /var/lib/k0s/pki/k0s-api*
#chown kube-apiserver /var/lib/k0s/pki/ccm*
#chown kube-apiserver /var/lib/k0s/pki/ca.key
#chown root /var/lib/k0s/pki/ca.crt
#chown konnectivity-server /var/lib/k0s/pki/konnectivity*
#chgrp root /var/lib/k0s/pki/*
#chown root /var/lib/k0s/pki/admin*
#chown kube-apiserver /var/lib/k0s/pki/apiserver-*
