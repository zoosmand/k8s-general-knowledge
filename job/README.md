# Kubernetes Job

<https://kubernetes.io/docs/concepts/workloads/controllers/job/>

# Get a job results
~~~ bash
kubectl logs jobs/jtest
~~~

## Restart a job's pod
~~~ bash
kubectl get pods --selector=job-name=jtest -o json | kubectl replace --force -f -
~~~
