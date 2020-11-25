# sftp-server

### New Build
```
oc new-build --strategy docker --binary --docker-image alpine:latest --name sftp-server
oc start-build sftp-server --from-dir . --follow --no-cache=true
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
    runAsUser: 0
  containers:
```

