#!/bin/bash

. image.sh

check armhf
download "https://downloads.raspberrypi.org/raspios_lite_armhf/images/raspios_lite_armhf-${RPIOS_VERSION}/${RPIOS_VERSION}-raspios-bookworm-armhf-lite.img.xz" armhf
uncompress armhf
./repack.sh
