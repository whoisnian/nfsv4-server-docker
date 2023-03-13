# nfsv4-server-docker

## Upstream
* https://github.com/GoogleCloudPlatform/nfs-server-docker
  * https://github.com/kubernetes/kubernetes/tree/master/test/images/volume/nfs
  * https://github.com/kubernetes/examples/tree/master/staging/volumes/nfs/nfs-data

## NFSv4 without rpcbind
* https://wiki.archlinux.org/title/NFS#Starting_the_server
* https://www.suse.com/support/kb/doc/?id=000019530

## Build
```sh
TAG=$(cat VERSION)
docker build ./src \
  -f ./src/Dockerfile \
  -t ghcr.io/whoisnian/nfsv4-server-docker:$TAG
```

## Run
The container will need to run with `CAP_SYS_ADMIN` or `--privileged`.
```sh
mkdir /tmp/exports
docker run \
  --rm --name nfsv4-server \
  --cap-add SYS_ADMIN \
  -p 2049:2049 \
  -v /tmp/exports:/exports \
  ghcr.io/whoisnian/nfsv4-server-docker:0.0.1
```
