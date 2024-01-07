# Kubernetes K0s

## Installation

### Stand-alone / single controller and worker
~~~ bash
sudo k0s install controller --single
sudo k0s start
~~~

### Cluster
<https://docs.k0sproject.io/v1.21.4+k0s.1/k0s-multi-node/>

#### Install controller
~~~ bash
sudo k0s default-config > k0s.yaml
sudo k0s install controller -c k0s.yaml
sudo k0s start
~~~

#### Generate a worker token
~~~ bash
sudo k0s token create --role=worker
# or
k0s token create --role=worker --expiry=100h > token-file
~~~

#### Add a worker to the cluster
~~~ bash
sudo k0s install worker --token-file /path/to/token/file
sudo k0s start
~~~

- on the existing controller
#### Add a controller to the cluster
~~~ bash
sudo k0s token create --role=controller --expiry=1h > token-file
~~~

- on the new controller
~~~ bash
sudo k0s install controller --token-file /path/to/token/file
sudo k0s start
~~~

#### Check controller status
~~~ bash
sudo k0s status
~~~

---

## Users and Groups
### Add user in a group
~~~ bash
# a cluster admin
sudo k0s kubeconfig admin > ~/.kube/admin.config
# or
sudo k0s kubeconfig create --groups "system:masters" mp-admin > ~/.kube/mp-admin.config
# a user with no privileges at the moment, included into a group
sudo k0s kubeconfig create --groups "default:operators" zoosman > ~/.kube/zoosman.config
~~~

## Environments
<https://kubernetes.io/docs/reference/generated/kubectl/kubectl-commands#config>

### Config file
~~~ bash
export KUBECONFIG=~/.kube/config
# or 
kubectl get all --kubeconfig ~/.kube/zoosman.config 
# or
export KUBECONFIG=~/.kube/admin.config:~/.kube/zoosman.config
~~~

### Merge several configs into one one
~~~ bash
kubectl config view --flatten > ~/.kube/config
export KUBECONFIG=~/.kube/config
~~~

---

## Some tips

### restart a pod
~~~ bash
kubectl get pod <pod_name> -o json | kubectl replace --force -f - 
# or
kubectl get pod <pod_name> -o yaml | kubectl replace --force -f - 
~~~

### Add label for a node
~~~ bash
kubectl label node/mp8 node-type=worker
# to check labels
kubectl get nodes --show-labels
~~~

### Change namespace in current context
~~~ bash
kubectl config set-context --current --namespace=default
~~~



* export POD_NAME=$(kubectl get pods --namespace default -l "app.kubernetes.io/name=sb-10,app.kubernetes.io/instance=sb-10" -o jsonpath="{.items[0].metadata.name}")

* export CONTAINER_PORT=$(kubectl get pod --namespace default $POD_NAME -o jsonpath="{.spec.containers[0].ports[0].containerPort}")

* kubectl --namespace default port-forward $POD_NAME 8080:$CONTAINER_PORT

* kubectl create configmap prometheus-config --from-file=./volumes/mnt/monitoring/configurations/prometheus/prometheus.yml -n monitoring

* nsenter -t $PID -u hostname

