# Local Docker Registry in Kubernetes
## Generate a self-signed sertificte

~~~ bash
/usr/bin/openssl req -newkey rsa:4096 -nodes -keyout ./crt/registry.key -x509 -sha256 -days 365 -subj "/C=CY/ST=Cyprus/L=Limassol/O=IPS IT Labs./OU=ASKUG/CN=askug.net" -addext "subjectAltName = DNS:reg.docker.askug.net, IP:10.203.10.20" -out ./crt/registry.crt
~~~

## Create namespase
~~~ bash
cat << EOF > ./namespace_docker.yaml
---
apiVersion: v1
kind: Namespace
metadata:
  name: docker

...
EOF

kubectl apply -f ./namespace_docker.yaml
~~~

---

## Create key/certificate and secret
### 1st method
~~~ bash
kubectl create secret tls registry-crt --cert=./crt/registry.crt --key=./crt/registry.key -n docker
~~~

### 2nd method
~~~ bash
# creash base64 hashes
cat ./crt/registry.key | openssl base64 -A
cat ./crt/registry.crt | openssl base64 -A

# paste hashes into yaml file
cat << EOF > ./secret_with_registry_key_cert.yaml
---
apiVersion: v1
type: kubernetes.io/tls
data:
  tls.crt: LS0tLS1CRUdXXXXXXXXXX==
  tls.key: LS0tLS1CRUdXXXXXXXXXX==
kind: Secret
metadata:
  name: registry-crt
  namespace: docker

...
EOF

kubectl apply -f ./secret_with_registry_key_cert.yaml
~~~

---

## Create Persistent Volume
### Local Storage (Node oriented. It is possible to address to the storage located in one node from another.)
~~~ bash
cat << EOF > ./persistent_volume_mp8_node0_local_storage_docker_registry.yaml
---
apiVersion: v1
kind: PersistentVolume
metadata:
  name: m8-local-storage-docker-registry
  labels:
    file-system: ext4
    physical-volume: lvm-partition
    max-size: 30GiB
    app: docker-registry
spec:
  capacity:
    storage: 20Gi
  volumeMode: Filesystem
  accessModes:
  - ReadWriteOnce
  persistentVolumeReclaimPolicy: Delete
  storageClassName: node0-local-storage-docker-registry
  local:
    path: /home/zoosman/dev/k0s/volumes/mnt/docker
  nodeAffinity:
    required:
      nodeSelectorTerms:
      - matchExpressions:
        - key: kubernetes.io/hostname
          operator: In
          values:
          - mp8

...
EOF

kubectl apply -f ./persistent_volume_mp8_node0_local_storage_docker_registry.yaml
~~~

---

## Create Persistent Volume Claim
~~~ bash
cat << EOF > ./persistent_volume_claim_docker_registry.yaml
---
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: registry-data
spec:
  # selector:
  #   matchLabels:
  #     app: docker-registry
  storageClassName: node0-local-storage-docker-registry
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 10Gi

...
EOF

kubectl apply -f ./persistent_volume_claim_docker_registry.yaml
~~~

---

## Create Deployment
~~~ bash
cat << EOF > ./deployment_docker_registry.yaml
---
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    app: docker-registry
  name: registry
  namespace: docker
spec:
  replicas: 1
  selector:
    matchLabels:
      app: docker-registry
  template:
    metadata:
      labels:
        app: docker-registry
    spec:
      nodeSelector:
        node-type: worker
      containers:
      - name: registry
        image: registry:2
        ports:
        - containerPort: 5000
        env:
        - name: REGISTRY_HTTP_TLS_CERTIFICATE
          value: "/certs/tls.crt"
        - name: REGISTRY_HTTP_TLS_KEY
          value: "/certs/tls.key"
        volumeMounts:
        - name: registry-crt
          mountPath: "/certs"
          readOnly: true
        - name: registry-data
          mountPath: "/var/lib/registry"
          subPath: "registry"
      volumes:
      - name: registry-crt
        secret:
          secretName: registry-crt
      - name: registry-data
        persistentVolumeClaim:
          claimName: registry-data

...
EOF

kubectl apply -f ./deployment_docker_registry.yaml
~~~

---

## Create Service
~~~ bash
cat << EOF > ./service_docker_registry.yaml
---
apiVersion: v1
kind: Service
metadata:
  name: registry-service
  namespace: docker
spec:
  type: LoadBalancer
  selector:
    app: docker-registry
  ports:
    - name: registry-tcp
      protocol: TCP
      port: 5000
      targetPort: 5000
  loadBalancerIP: 10.203.10.20

...
EOF

kubectl apply -f ./service_docker_registry.yaml
~~~

---

## Checking connection
~~~ bash
curl --cacert ./crt/registry.crt https://reg.docker.askug.net:5000/v2/
~~~

### Add the Regustry Self-signed certificate to trusted storage
~~~ bash
# on Ubutu/Debian
sudo cp ./crt/registry.crt /etc/ssl/certs
# refresh the storage
sudo update-ca-certificates --fresh --verbose
~~~

~~~ bash
curl https://reg.docker.askug.net:5000/v2/
~~~

~~~ bash
docker tag prometheus:latest reg.docker.askug.net:5000/prometheus:latest
docker push reg.docker.askug.net:5000/prometheus:latest
~~~

