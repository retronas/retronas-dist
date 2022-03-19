FROM i386/debian:latest

RUN apt-get update
RUN apt-get clean

RUN apt-get install -y libarchive-tools
RUN apt-get install -y cpio
RUN apt-get install -y xorriso
RUN apt-get install -y curl
