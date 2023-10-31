# nfsv4-server-docker

## Upstream
* https://github.com/GoogleCloudPlatform/nfs-server-docker
  * https://github.com/kubernetes/kubernetes/tree/master/test/images/volume/nfs
  * https://github.com/kubernetes/examples/tree/master/staging/volumes/nfs/nfs-data

## NFSv4 without rpcbind
* https://wiki.archlinux.org/title/NFS#Starting_the_server
* https://www.suse.com/support/kb/doc/?id=000019530

## Run
The container will need to run with `--privileged`.
```sh
mkdir /tmp/exports
docker run -d \
  --name nfsv4-server \
  --privileged \
  -p 2049:2049 \
  -v /tmp/exports:/exports \
  ghcr.io/whoisnian/nfsv4-server-docker:0.0.3

# about `--cap-add SYS_ADMIN`: https://github.com/moby/moby/issues/16429
```
