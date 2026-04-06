#! /bin/bash
docker rm -f centos7 ubuntu fedora
docker run -d --name centos7 centos:7 sleep infinity
docker run -d --name fedora pycontribs/fedora:latest sleep infinity
docker run -d --name ubuntu ubuntu:latest sleep infinity
docker exec ubuntu apt-get update && docker exec ubuntu apt-get install -y python3 

ansible-playbook -i inventory/prod.yml site.yml

docker stop centos7 ubuntu fedora