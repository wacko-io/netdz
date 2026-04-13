#!/bin/bash
set -e
docker rm -f rockylinux8

docker run -d \
  --name rockylinux8 \
  --privileged \
  --cgroupns=host \
  -v /sys/fs/cgroup:/sys/fs/cgroup:rw \
  geerlingguy/docker-rockylinux8-ansible:latest

docker exec -it rockylinux8 yum install -y python3
docker exec -it rockylinux8 bash -lc 'python3 --version && systemctl status'