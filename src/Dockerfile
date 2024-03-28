# syntax=docker.io/docker/dockerfile:1.7
# https://docs.docker.com/build/dockerfile/frontend/

# Copyright 2016 The Kubernetes Authors.
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

FROM debian:12-slim

RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
  --mount=type=cache,target=/var/lib/apt,sharing=locked \
  rm -f /etc/apt/apt.conf.d/docker-clean && \
  echo 'Binary::apt::APT::Keep-Downloaded-Packages "true";' >/etc/apt/apt.conf.d/keep-cache && \
  apt-get update && apt-get install --no-install-recommends -y nfs-kernel-server

COPY --chmod=755 docker-entrypoint.sh /usr/local/bin/

VOLUME /exports

EXPOSE 2049/tcp

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
