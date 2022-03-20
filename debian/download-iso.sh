#!/bin/bash

function check_for_iso {
  local EXPECTED_FILENAME="debian-$2-$1-netinst.iso"
  for file in $(pwd)/iso-cache/*; do
      local FILENAME=$(basename $file)
      if [[ $FILENAME == $EXPECTED_FILENAME ]]; then
        export EXISTING_ISO=$FILENAME
        break
      fi
  done
}

function download_iso {
  URL="https://laotzu.ftp.acc.umu.se/debian-cd/current/$1/iso-cd/debian-$2-$1-netinst.iso"
  echo "Downloading from: $URL"
  curl $URL --output iso-cache/debian-$2-$1-netinst.iso
  check_for_iso $1
  echo "Downloaded $EXISTING_ISO"
}

unset EXISTING_ISO
check_for_iso $1 $2
if [ -z ${EXISTING_ISO+x} ]; then echo "No existing '$1' iso of version '$2' found. Downloading..." && download_iso $1 $2; else echo "Existing iso will be used: '$EXISTING_ISO' Remove it first if you wish to download another."; fi
