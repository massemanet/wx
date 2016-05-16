FROM ubuntu:16.04

RUN echo "deb http://ppa.launchpad.net/wxformbuilder/release/ubuntu xenial main" >> /etc/apt/sources.list &&\
    apt-get update &&\
    apt-get install -y --allow-unauthenticated xterm aptitude emacs-nox wxformbuilder

