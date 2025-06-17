# Kubernetes REST API

## K8s API Access

### Service Account 
* Create a Service Account
  ~~~ bash
  cat << EOF | kubectl apply -f -
  ---
  apiVersion: v1
  kind: ServiceAccount
  metadata:
    name: cluster-api-operator
    namespace: kube-system
  automountServiceAccountToken: false

  ...
  EOF
  ~~~

* Delete the Service Account
  ~~~ bash
  kubectl delete sa cluster-api-operator -n kube-system
  ~~~


### Binding Service Account with Roles/ClusterRoles
* Create a binding
  ~~~ bash
  cat << EOF | kubectl apply -f -
  ---
  apiVersion: rbac.authorization.k8s.io/v1
  kind: ClusterRoleBinding
  metadata:
    name: cluster-api-operator
    annotations:
      rbac.authorization.kubernetes.io/autoupdate: "true"
  subjects:
  - kind: ServiceAccount
    name: cluster-api-operator
    namespace: kube-system
  roleRef:
    apiGroup: rbac.authorization.k8s.io
    kind: ClusterRole
    name: operator

  ...
  EOF
  ~~~

* Delete the binding
  ~~~ bash
  kubectl delete clusterrolebindings/cluster-api-operator
  ~~~

### Secret Token
* Create a token
  ~~~ bash
  kubectl apply -f - << EOF
  ---
  apiVersion: v1
  kind: Secret
  metadata:
    name: cluster-api-operator-token
    namespace: kube-system
    annotations:
      kubernetes.io/service-account.name: cluster-api-operator
  type: kubernetes.io/service-account-token

  ...
  EOF
  ~~~

* Control issuing the token
  ~~~ bash
  kubectl describe secret cluster-api-operator-token -n kube-system
  ~~~

* Delete the token
  ~~~ bash
  kubectl delete secret cluster-api-operator-token -n kube-system
  ~~~

---

### Tips and Tricks 

* Add CA certificate into the local storage <br>--- *the curl argument "-k" might be skipped then* ---
  ~~~ bash
  sudo cp ./CA/ca.crt /etc/ssl/certs
  sudo update-ca-certificates --verbose --fresh
  ~~~

* Get the token value
  ~~~ bash
  export K0S_TOKEN=$(kubectl get secret cluster-api-operator-token -n kube-system -o jsonpath='{.data.token}' | base64 --decode)
  ~~~

* Get the API server value
  ~~~ bash
  export K0S_CLUSTER=kube.askug.net
  export K0S_APISERVER=$(kubectl config view --kubeconfig ./usr/operator.config -o jsonpath="{.clusters[?(@.name==\"$K0S_CLUSTER\")].cluster.server}")
  ~~~

* Get API info
  ~~~ bash
  curl -k -X GET -H "Authorization: Bearer $K0S_TOKEN" $K0S_APISERVER/api
  ~~~

* Get pods info from the "monitoring" namespace
  ~~~ bash
  curl -k -X GET -H "Authorization: Bearer $K0S_TOKEN" $K0S_APISERVER/api/v1/namespaces/monitoring/pods
  ~~~

* Get pods info
  ~~~ bash
  curl -k -X GET -H "Authorization: Bearer $K0S_TOKEN" $K0S_APISERVER/api/v1/pods
  ~~~

* Get the "remote-development-volume" volume info
  ~~~ bash
  curl -k -X GET -H "Authorization: Bearer $K0S_TOKEN" $K0S_APISERVER/api/v1/persistentvolumes/remote-development-volume/status
  ~~~

---

### Links 

<https://kubernetes.io/docs/tasks/administer-cluster/access-cluster-api/>

---

&copy; 2017-2025, Askug Ltd.
