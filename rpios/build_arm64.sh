#!/bin/bash

. image.sh

function download_arm64 {
  download "https://downloads.raspberrypi.org/raspios_lite_arm64/images/raspios_lite_arm64-2025-05-13/2025-05-13-raspios-bookworm-arm64-lite.img.xz"
}

check arm64
download_arm64
uncompress arm64
./repack.sh
