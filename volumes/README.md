# Kubernetes K0s

- to set up a persistent volume into a cluster, user has to have specific privileges on the cluster level
- to claim a volume, a user needs privileges on the namespace level
- "ReadWriteOnce" or "ReadOnlyOnce" mean access to the storage only from the node where it is located 
- "ReadWriteMany" or "ReadOnlyMany" mean access to the storage from any nodes 

## Volumes
### Persistemt Volume
#### Local Storage (Node oriented. It is possible to address to the storage located in one node from another.)
~~~ bash
cat << EOF > ./persistent_volume_mp8_node0_local_storage_monitoring.yaml
---
apiVersion: v1
kind: PersistentVolume
metadata:
  name: m8-local-storage-monitoring
  labels:
    file-system: ext4
    physical-volume: lvm-partition
    max-size: 20Gi
    app: sb-11
spec:
  capacity:
    storage: 20Gi
  volumeMode: Filesystem
  accessModes:
  - ReadWriteOnce
  persistentVolumeReclaimPolicy: Delete
  storageClassName: node0-local-storage-monitoring
  local:
    path: /home/zoosman/dev/k0s/volumes/mnt/monitoring
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

kubectl apply -f ./persistent_volume_mp8_node0_local_storage_monitoring.yaml
~~~

#### Hadoop

#### Seph

#### ISCI

#### NFS

#### Cloud specific storages
##### AWS

##### GCP

##### Azure

---
---
---

### Persistent Volume Claim
- to choose which persistent volume to use in a paticular claim, use either **storageClassName** or labels matching

#### Read only volume claim for configuraton files
~~~ bash
cat << EOF > ./persistent_volume_claim_ro_10_MiB.yaml
---
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: configurations
spec:
  # selector:
  #   matchLabels:
  #     app: sb-11
  storageClassName: node0-local-storage
  accessModes:
    - ReadOnlyMany
  resources:
    requests:
      storage: 10Mi

...
EOF

kubectl apply -f ./persistent_volume_claim_ro_10_MiB.yaml
~~~


#### Read/Write volume claim for caches
~~~ bash
cat << EOF > ./persistent_volume_claim_rw_20_GiB.yaml
---
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: caches
spec:
  # selector:
  #   matchLabels:
  #     app: sb-11
  storageClassName: node0-local-storage
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 20Gi

...
EOF

kubectl apply -f ./persistent_volume_claim_rw_20_GiB.yaml
~~~


#### Read/Write volume claim for logs
~~~ bash
cat << EOF > ./persistent_volume_claim_rw_10_GiB.yaml
---
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: logs
spec:
  # selector:
  #   matchLabels:
  #     app: sb-11
  storageClassName: node0-local-storage
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 10Gi

...
EOF

kubectl apply -f ./persistent_volume_claim_rw_10_GiB.yaml
~~~
