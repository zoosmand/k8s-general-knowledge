# Kubernetes RBAC

## RBAC User/Group Administration
### Create a user
#### Simple user with no group
~~~ bash
k0s kubeconfig create zoosman
~~~

#### A user in group
~~~ bash
# a cluster admin
k0s kubeconfig create --groups "system:masters" admin > ~/.kube/admin.config
# a user with no privileges at the moment, included into a group
k0s kubeconfig create --groups "default:operators" zoosman > ~/.kube/zoosman.config
~~~

### Crate a role
~~~ bash
cat << EOF > ./role_default_operators.yaml
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

kubectl apply -f ./role_default_operators.yaml
~~~

### Bind roles
#### Role bindings in default namespace
~~~ bash
cat << EOF > ./rolebinding_default_operator_with_operators_group.yaml
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

kubectl apply -f ./rolebinding_default_operator_with_operators_group.yaml
~~~

#### Cluster role bindings with a user
~~~ bash
cat << EOF > ./clusterrolebinding_role_view_with_user_auditor.yaml
---
kind: ClusterRoleBinding
apiVersion: rbac.authorization.k8s.io/v1

metadata:
  name: cluster-viewer

subjects:
- kind: User
  name: auditor

roleRef:
  kind: ClusterRole
  name: view

...
EOF

kubectl apply -f ./clusterrolebinding_role_view_with_user_auditor.yaml
~~~

#### Cluster role bindings with a group
~~~ bash
cat << EOF > ./clusterrolebinding_role_view_with_group_auditors.yaml
---
kind: ClusterRoleBinding
apiVersion: rbac.authorization.k8s.io/v1

metadata:
  name: cluster-viewers

subjects:
- kind: Group
  name: system:auditors

roleRef:
  kind: ClusterRole
  name: view

...
EOF

kubectl apply -f ./clusterrolebinding_role_view_with_group_auditors.yaml
~~~

