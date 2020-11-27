# Deploy sftpserver Openshift 3.11

#### N.B

Before running the deploy step populate the * authorized_keys * file with the desired public key.

### Deploy
```
oc new-build --strategy docker --binary --docker-image centos:centos7 --name sftpserver
oc start-build sftpserver --from-dir . --follow
oc new-app sftpserver
```

### Create service account
```
oc create serviceaccount sftp-sa -n test-project
```

### Anyuid Permission
```
oc adm policy add-scc-to-user anyuid -z sftp-sa
```

### Edit dc sftpserver
```
oc edit dc sftpserver

spec:
  serviceAccountName: sftp-sa
  securityContext:
    runAsUser: 1001
    runAsGroup: 1001
    fsGroup: 1001
  containers:
```

### Set pvc volume
```
oc set volumes dc sftpserver --add --name=pvc-sftpserver --claim-name=pvc-sftpserver --mount-path=/home/timbube/upload --sub-path=upload
```
