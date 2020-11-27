# sftp-server

### New Build
```
oc new-build --strategy docker --binary --docker-image centos:centos7 --name sftp-server
oc start-build sftp-server --from-dir . --follow
oc new-app sftp-server
```

### Create service account
```
oc create serviceaccount sftp-sa -n test-project
```

### Anyuid Permission
```
oc adm policy add-scc-to-user anyuid -z sftp-sa
```

### Edit dc sftp-server
```
oc edit dc sftp-server

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
oc set volumes dc sftp-server --add --name=pvc-sftp --claim-name=pvc-sftp --mount-path=/home/timbube/upload --sub-path=upload
```
