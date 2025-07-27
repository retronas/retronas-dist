#!/bin/bash

function check {
  unset EXISTING_RPIOS_IMG
  for file in $(pwd)/iso-cache/*; do
      local FILENAME=$(basename $file)
      if [[ $FILENAME == *"raspios"*"$1"*.img* ]]; then
        export EXISTING_RPIOS_IMG=$FILENAME
        break
      fi
  done
}

function uncompress {
  for file in $(pwd)/iso-cache/*; do
      local FILENAME=$(basename $file)
      if [[ $FILENAME == *"raspios"*"$1"*.xz ]]; then
        echo "Uncompressing $FILENAME"
        cd iso-cache
        xz --decompress $FILENAME
        cd ..
        check $1
        break
      fi
  done
}

set -x

function download {
  if [ -z $EXISTING_RPIOS_IMG ]
  then
    mkdir -p iso-cache
    URL="$1"
    echo "Downloading from: $URL"
    wget -c -P iso-cache $URL
  fi 
}


