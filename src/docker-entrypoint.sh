#!/bin/bash
# Copyright 2015 The Kubernetes Authors.
# Copyright 2018 Google LLC
# Copyright 2024 whoisnian
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

function start() {
    # unset gid
    # # accept "-G gid" option
    # while getopts "G:" opt; do
    #     case ${opt} in
    #     G) gid=${OPTARG} ;;
    #     esac
    # done
    # shift $(($OPTIND - 1))

    OPT_RW="rw"
    if [ -n "$READ_ONLY" ]; then
        OPT_RW="ro"
    fi
    OPT_HOST="*"
    if [ -n "$ALLOW_HOST" ]; then
        OPT_HOST="$ALLOW_HOST"
    fi

    # prepare /etc/exports
    # fsid=0: needed for NFSv4
    FULL_CFG="/exports $OPT_HOST($OPT_RW,fsid=0,sync,no_subtree_check,no_root_squash,insecure)"

    echo "Serving $FULL_CFG"
    echo "$FULL_CFG" >>/etc/exports

    # NFSv4 can run without rpcbind
    #
    # /usr/sbin/rpcinfo 127.0.0.1 > /dev/null; s=$?
    # if [ $s -ne 0 ]; then
    #    echo "Starting rpcbind"
    #    /sbin/rpcbind -w
    # fi

    mount -t nfsd nfds /proc/fs/nfsd

    # -N 2 -N 3: disable NFSv2 and NFSv3
    /usr/sbin/rpc.mountd -N 2 -N 3

    /usr/sbin/exportfs -r
    # -G 10 to reduce grace time to 10 seconds (the lowest allowed)
    /usr/sbin/rpc.nfsd -G 10 -N 3

    # For NFSv2 and NFSv3, the Network Status Monitor protocol (or NSM for short) is used to notify NFS peers of reboots
    # /sbin/rpc.statd --no-notify
    echo "NFS started"
}

function stop() {
    echo "Stopping NFS"

    /usr/sbin/rpc.nfsd 0
    /usr/sbin/exportfs -au
    /usr/sbin/exportfs -f

    kill $(pidof rpc.mountd)
    umount /proc/fs/nfsd
    echo >/etc/exports
    exit 0
}

if [ -z "$@" ]; then
    trap stop TERM

    start

    # Ugly hack to do nothing and wait for SIGTERM
    while true; do
        sleep 5
    done
else
    exec "$@"
fi
