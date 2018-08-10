#!/bin/sh
echo 'deb https://apt.dockerproject.org/repo debian-stretch main' >> /etc/apt/sources.list.d/docker.list
apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
apt-get update && apt-get install docker-engine -yy

