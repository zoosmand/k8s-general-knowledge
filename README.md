# Kubernetes K0s Cluster

## Installation

### Stand-alone / single controller and worker
  ~~~ bash
  sudo k0s install controller --single
  sudo k0s start
  ~~~

### Cluster
  - Install controller
    ~~~ bash
    sudo k0s default-config > k0s.yaml
    sudo k0s install controller -c k0s.yaml
    sudo k0s start
    ~~~

  - Generate a worker token
    ~~~ bash
    sudo k0s token create --role=worker
    # or
    k0s token create --role=worker --expiry=100h > token-file
    ~~~

  - Add a worker to the cluster (on the new worker node)
    ~~~ bash
    sudo k0s install worker --token-file /path/to/token/file
    sudo k0s start
    ~~~

  - Generate a controller token
    ~~~ bash
    sudo k0s token create --role=controller --expiry=1h > token-file
    ~~~

  - Add a controller to the cluster (on the new controller node)
    ~~~ bash
    sudo k0s install controller --token-file /path/to/token/file
    sudo k0s start
    ~~~

  - Check status
    ~~~ bash
    sudo k0s status
    ~~~

---

## Roles, Groups, ans Users Management

  - Create a simple "admin" user with "cluster-admin" role by default
    ~~~ bash
    sudo k0s kubeconfig admin > ~/.kube/admin.config
    ~~~


  - Create a user including it into the "system:masters" group which is binded to "cluster-admin" role (the same access as on the previouse step)
    ~~~ bash 
    sudo k0s kubeconfig create --groups "system:masters" cluster-admin > ~/.kube/cluster-admin.config
    ~~~

  - Create a user including it into the "default:operators" which is not exist at the moment 
    ~~~ bash
    sudo k0s kubeconfig create --groups "default:operators" operator > ~/.kube/operator.config
    ~~~

---

## Refactor config file
  * Usage of the environment variable
    - from a single configuratoin file
      ~~~ bash
      export KUBECONFIG=~/.kube/admin.config
      ~~~
    - join several configuration files
      ~~~ bash
      export KUBECONFIG=~/.kube/cluster-admin.config:~/.kube/operator.config
      ~~~

  * Merge several configs into a single one
    ~~~ bash
    kubectl config view --flatten > ~/.kube/config
    export KUBECONFIG=~/.kube/config
    ~~~

  * Usage of a particular config e.g.
    ~~~ bash 
    kubectl get all --kubeconfig ~/.kube/operator.config 
    ~~~

---

## Tips and Tricks

  * Restarting pods
    ~~~ bash
    kubectl get pod <pod_name> -o json | kubectl replace --force -f - 
    # or
    kubectl get pod <pod_name> -o yaml | kubectl replace --force -f - 
    ~~~

  * Labeling nodes
    - set up a label
    ~~~ bash
    kubectl label node/mp8 node-type=worker
    ~~~
    - check labels
    ~~~ bash
    kubectl get nodes --show-labels
    ~~~

  * Change namespace in current context
    ~~~ bash
    kubectl config set-context --current --namespace=default
    ~~~

  * Forward the port of a container
    - get a pod name into an env var
      ~~~ bash
      export POD_NAME=$(kubectl get pods -n <namespace> -l "app.kubernetes.io/name=<application_name>,app.kubernetes.io/instance=<application_name>" -o jsonpath="{.items[0].metadata.name}")
      ~~~

    - get a container port into an env var
      ~~~ bash
      export CONTAINER_PORT=$(kubectl get pod -n <namespace> $POD_NAME -o jsonpath="{.spec.containers[0].ports[0].containerPort}")
      ~~~

    - forward the port of a container
      ~~~ bash
      kubectl -n <namespace> port-forward $POD_NAME 8080:$CONTAINER_PORT
      ~~~

  * Create a ConfigMap from a file source
    ~~~ bash
    kubectl create configmap <configmap-name> --from-file=/path/to/the/source/file -n <namespace>
    ~~~

  * Usage of namespace entering utility
    ~~~ bash
    nsenter -t $PID -u hostname
    ~~~

---

## Useful Links

* <https://docs.k0sproject.io/head/k0s-multi-node/>
* <https://kubernetes.io/docs/reference/generated/kubectl/kubectl-commands#config>


---

&copy; 2017-2025, Askug Ltd.
