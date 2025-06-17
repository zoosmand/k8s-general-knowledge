# Kubernetes RBAC

## RBAC User/Group Administration

### Roles

* Create an "operator" role in the "default" namespace
  ~~~ bash
  cat << EOF | kubectl apply -f -
  ---
  kind: Role
  apiVersion: rbac.authorization.k8s.io/v1

  metadata:
    namespace: default
    name: operator

  rules:
    - apiGroups: ["", "apps", "extensions"]
      resources: ["deployments", "daemonsets", "services", "statefulsets", "pods", "replicasets"]
      verbs: ["*"]

    - apiGroups: [""]
      resources: ["pods/ephemeralcontainers", "pods/log", "pods/attach"]
      verbs: ["*"]

    - apiGroups: [""]
      resources: ["persistentvolumeclaims"]
      verbs: ["*"]

    - apiGroups: [""]
      resources: ["configmaps", "secrets"]
      verbs: ["get", "list", "watch", "create", "update", "delete"]

    - apiGroups: ["batch"]
      resources: ["cronjobs", "jobs"]
      verbs: ["*"]

    - apiGroups: ["extensions"]
      resources: [""]
      verbs: [""]

    - apiGroups: ["", "autoscaling"]
      resources: ["replicationcontrollers", "horizontalpodautoscalers"]
      verbs: ["get", "list", "watch"]

    - apiGroups: ["rbac.authorization.k8s.io"]
      resources: ["roles", "rolebindings"]
      verbs: ["list"]

  ...
  EOF
  ~~~

* Delete the "operator" Role from the "default" namespace
  ~~~ bash
  kubectl delete role/operator -n default
  ~~~

---

### Cluster Roles

* Create an "operator" ClusterRole
  ~~~ bash
  cat << EOF | kubectl apply -f -
  ---
  kind: ClusterRole
  apiVersion: rbac.authorization.k8s.io/v1

  metadata:
    name: operator

  rules:
    - apiGroups: ["", "apps", "extensions"]
      resources: ["deployments", "daemonsets", "services", "statefulsets", "pods", "replicasets"]
      verbs: ["*"]

    - apiGroups: [""]
      resources: ["pods/ephemeralcontainers", "pods/log", "pods/attach"]
      verbs: ["*"]

    - apiGroups: [""]
      resources: ["persistentvolumeclaims"]
      verbs: ["*"]

    - apiGroups: [""]
      resources: ["persistentvolumes", "persistentvolumes/status"]
      verbs: ["*"]

    - apiGroups: [""]
      resources: ["configmaps", "secrets"]
      verbs: ["get", "list", "watch", "create", "update", "delete"]

    - apiGroups: ["batch"]
      resources: ["cronjobs", "jobs"]
      verbs: ["*"]

    - apiGroups: ["extensions"]
      resources: [""]
      verbs: [""]

    - apiGroups: ["", "autoscaling"]
      resources: ["replicationcontrollers", "horizontalpodautoscalers"]
      verbs: ["get", "list", "watch"]

    - apiGroups: ["rbac.authorization.k8s.io"]
      resources: ["roles", "rolebindings"]
      verbs: ["list"]

    - apiGroups: ["rbac.authorization.k8s.io"]
      resources: ["clusterroles", "clusterrolebindings"]
      verbs: ["list"]

  ...
  EOF
  ~~~

* Delete the "operator" ClusterRole
  ~~~ bash
  kubectl delete clusterrole/operator
  ~~~

---

### Binding Roles/ClusterRoles

* Bind the Role "operator" with the group "default:operators" in the "default" namespace
  ~~~ bash
  cat << EOF | kubectl apply -f -
  ---
  kind: RoleBinding
  apiVersion: rbac.authorization.k8s.io/v1

  metadata:
    name: operators
    namespace: default

  subjects:
  - kind: Group
    name: default:operators

  roleRef:
    kind: Role
    name: operator

  ...
  EOF
  ~~~

* Bind the Role "operator" with the user "operator" and the group "default:operators" in the "default" namespace
  ~~~ bash
  cat << EOF | kubectl apply -f -
  ---
  kind: RoleBinding
  apiVersion: rbac.authorization.k8s.io/v1

  metadata:
    name: operators
    namespace: default

  subjects:
  - kind: User
    name: operator
  - kind: Group
    name: default:operators

  roleRef:
    kind: Role
    name: operator

  ...
  EOF
  ~~~

* Delete the binding of "operator" Role from the "default" namespace
  ~~~ bash
  kubectl delete rolebindings/operators -n default
  ~~~

---


* Bind Cluster Role "operator" with the user "operator" and, the group "system:operators", and the service account "clister-api-operator"
  ~~~ bash
  cat << EOF | kubectl apply -f -
  ---
  kind: ClusterRoleBinding
  apiVersion: rbac.authorization.k8s.io/v1

  metadata:
    name: cluster-operators
    annotations:
      rbac.authorization.kubernetes.io/autoupdate: "true"

  subjects:
  - kind: User
    name: operator
    namespace: default
  - kind: Group
    name: system:operators
  - kind: ServiceAccount
    name: cluster-api-operator
    namespace: kube-system

  roleRef:
    kind: ClusterRole
    name: operator

  ...
  EOF
  ~~~

* Delete the binding of "operator" ClusterRole
  ~~~ bash
  kubectl delete clusterrolebindings/cluster-operators
  ~~~


---

&copy; 2017-2025, Askug Ltd.