FROM golang:1.18

RUN apt-get update --fix-missing
RUN apt-get install -y git unzip libarchive-tools qemu-user-static e2fsprogs dosfstools wget kpartx

RUN wget https://releases.hashicorp.com/packer/1.4.5/packer_1.4.5_linux_amd64.zip
RUN unzip packer_1.4.5_linux_amd64.zip
RUN mv packer /usr/local/bin/

RUN mkdir -p /root/.packer.d/plugins
RUN curl --fail --silent --show-error --location \
    -o /root/.packer.d/plugins/packer-builder-arm-image \
    https://github.com/solo-io/packer-builder-arm-image/releases/download/v0.1.3/packer-builder-arm-image
RUN chmod a+x /root/.packer.d/plugins/packer-builder-arm-image
