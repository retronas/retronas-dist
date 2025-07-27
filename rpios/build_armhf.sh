#!/bin/bash

. image.sh

check armhf
download "https://downloads.raspberrypi.org/raspios_lite_armhf/images/raspios_lite_armhf-2025-05-13/2025-05-13-raspios-bookworm-armhf-lite.img.xz" armhf
uncompress armhf
./repack.sh
