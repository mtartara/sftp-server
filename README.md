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
    runAsNonRoot: true
    runAsUser: 1001
  containers:
```

### InitContainer
```
initContainers:
  - command:
  - chown
  - '100'
  - /tmp/authorized_keys
  image: 'alpine:latest
  securityContext:
    runAsUser: 0
  volumeMounts:
  - mountPath: /tmp/authorized_keys
    name: volume-r5cjm
    subPath: authorized_keys
```

### Create ConfigMaps
```
oc create configmap pub-key --from-file=authorized_keys
```

### Add volume
```
oc set volume dc/sftp-server --add --mount-path=/home/timbube/.ssh/authorized_keys --configmap-name=pub-key --default-mode=0600
```

### Change Mount
```
volumeMounts:
  - mountPath: /home/timbube/.ssh/authorized_keys
    name: volume-5jlcx
    subPath: authorized_keys
```
