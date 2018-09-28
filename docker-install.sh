#!/bin/sh
apt-get update -yy && apt-get upgrade -yy && apt-get install apt-transport-https -yy
echo 'deb https://apt.dockerproject.org/repo debian-stretch main' >> /etc/apt/sources.list.d/docker.list
apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
apt-get install docker-engine --allow-unauthenticated -yy

