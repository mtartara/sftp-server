# Deploy sftpserver Openshift 3.11

#### N.B

SFTP server run with root privilegies.

Before running the deploy step populate the * authorized_keys * file with the desired public key.

### Deploy
```
oc new-build --strategy docker --binary --docker-image centos:centos7 --name sftpserver
oc start-build sftpserver --from-dir . --follow
oc new-app sftpserver
```

### ServiceAccount
```
oc create serviceaccount sftp-sa -n test-project
```

### Add ServiceAccount to anyuid SCC
```
oc adm policy add-scc-to-user anyuid -z sftp-sa
```

### Add SecurityContext and ServiceAccount to Deployment
```
oc edit dc sftpserver

spec:
  serviceAccountName: sftp-sa
  securityContext:
    runAsUser: 0
    runAsGroup: 1001
    fsGroup: 1001
  containers:
```
### Create PVC volume
```
oc create -f pvc-sftpserver.yaml
```

### Set PVC volume
```
oc set volumes dc sftpserver --add --name=pvc-sftpserver --claim-name=pvc-sftpserver --mount-path=/home/timbube/upload --sub-path=upload
```

### Create ConfigMap sftpserver-key
```
oc create configmap sftpserver-key --from-file=authorized_keys
```

### Set ConfigMap sftpserver-key
```
oc set volumes dc/sftpserver --add --configmap-name=sftpserver-key --default-mode=0600 --mount-path=/home/timbube/.ssh/authorized_keys --sub-path=authorized_keys
```
The authorized_keys have root:1001 owner and 0640 permission.

### Create ConfigMap sftpserver-config
```
oc create configmap sftpserver-config --from-file=sshd_config
```

### Set ConfigMap sftpserver-config
```
oc set volumes dc/sftproot --add --configmap-name=sftpserver-config --default-mode=777 --mount-path=/etc/ssh/sshd_config --sub-path=sshd_config
```

