# Kubenetes Test Pod
## The pod runs the OpenSSH server

### Change or create the file ~/.ssh/config
Dute to the pod restarts after an SSH session is over, it would be better not control the known hosts.
~~~ bash
cat << EOF | tee -a ~/.ssh/config

Host 10.203.10.30
  User root
  StrictHostKeyChecking no
  UserKnownHostsFile /dev/null
EOF
~~~

### Connect to the pod
Depending of the IP and port the pod is assigned, it might differs.
Password is "123456". To change it, edit the pod.yaml file.
~~~ bash
ssh root@10.203.10.30
~~~

If you don't want to change the ~/.ssh/config file, you can connect with extra ssh arguments
~~~ bash
ssh root@10.203.10.30 -o StrictHostKeychecking=no -o UserKnownHostsFile=/dev/null
~~~

### Restrat job's pods 
~~ bash
kubectl get pods --selector=job-name=pushgateway-test -o json | kubectl replace --force -f -
~~~

