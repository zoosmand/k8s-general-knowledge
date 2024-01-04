# Kubernetes REST API

<https://kubernetes.io/docs/tasks/administer-cluster/access-cluster-api/>

export K0S_TOKEN=$(kubectl get secret rest-admin-token -o jsonpath='{.data.token}' | base64 -d)

export K0S_APISERVER=$(kubectl config view -o jsonpath="{.clusters[?(@.name==\"mp8\")].cluster.server}")

curl -X GET $K0S_APISERVER/api --header "Authorization: Bearer $K0S_TOKEN" --insecure

curl -k -X GET -H "Authorization: Bearer $K0S_TOKEN" $K0S_APISERVER/api/v1/namespaces/monitoring/pods

curl -k -X GET -H "Authorization: Bearer $K0S_TOKEN" $K0S_APISERVER/api/v1/pods


