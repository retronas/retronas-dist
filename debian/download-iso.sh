#!/bin/bash

function check_for_iso {
  local EXPECTED_FILENAME="debian-*-$1-netinst.iso"
  OUTPUT=$(ls iso-cache/$EXPECTED_FILENAME)
  echo $OUTPUT
  if [[ $OUTPUT != "" ]]; then
    export EXISTING_ISO=$(basename $OUTPUT)
  fi
}

function download_iso {
  mkdir -p iso-cache
  BASE_URL="https://cdimage.debian.org/debian-cd/current/$1/iso-cd/"
  ISO_FILENAME=$(curl -L $BASE_URL | grep -Eo "debian-([0-9]+(\.[0-9]+)+)-$1-netinst\.iso" | head -1)
  echo $ISO_FILENAME
  URL="https://cdimage.debian.org/debian-cd/current/$1/iso-cd/$ISO_FILENAME"
  echo "Downloading from: $URL"
  curl -L $URL --output iso-cache/$ISO_FILENAME
  check_for_iso $1
  echo "Downloaded $ISO_FILENAME"
}

unset EXISTING_ISO
check_for_iso $1
if [ -z ${EXISTING_ISO+x} ]; then echo "No existing '$1' iso found. Downloading..." && download_iso $1; else echo "Existing iso will be used: '$EXISTING_ISO' Remove it first if you wish to download another."; fi
