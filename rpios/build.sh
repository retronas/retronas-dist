#!/bin/bash

#!/bin/bash

function check_for_iso {
  for file in $(pwd)/iso-cache/*; do
      local FILENAME=$(basename $file)
      if [[ $FILENAME == *"raspios"*.img ]]; then
        export EXISTING_RPIOS_IMG=$FILENAME
        break
      fi
  done
}

function unzip_iso {
  for file in $(pwd)/iso-cache/*; do
      local FILENAME=$(basename $file)
      if [[ $FILENAME == *"raspios"*.zip ]]; then
        echo $FILENAME
        unzip iso-cache/$FILENAME -d iso-cache
        rm iso-cache/$FILENAME
        break
      fi
  done
}

function download_iso {
  mkdir -p iso-cache
  URL="https://downloads.raspberrypi.org/raspios_lite_armhf/images/raspios_lite_armhf-2022-01-28/2022-01-28-raspios-bullseye-armhf-lite.zip"
  echo "Downloading from: $URL"
  wget -P iso-cache $URL
  unzip_iso
  check_for_iso
  echo "Downloaded $EXISTING_RPIOS_IMG"
}

unset EXISTING_RPIOS_IMG
check_for_iso
if [ -z ${EXISTING_RPIOS_IMG+x} ]; then echo "No cached raspbian image found. Downloading..." && download_iso; else echo "Existing iso will be used: '$EXISTING_RPIOS_IMG' Remove it first if you wish to download another."; fi

echo Copying image to temporary directory...
mkdir -p tmp
cp iso-cache/$EXISTING_RPIOS_IMG tmp

echo Requesting root permission for setting up loop devices
LOOP_DEVICE=$(sudo losetup -f)
MAPPER_STRING="/dev/mapper"
PARTITION="${LOOP_DEVICE/"/dev"/"$MAPPER_STRING"}p2"
echo Free loop device found: $LOOP_DEVICE
echo Mapper at $MAPPER

sudo losetup $LOOP_DEVICE tmp/$EXISTING_RPIOS_IMG

sudo kpartx -a $LOOP_DEVICE
sudo e2fsck -f $PARTITION
sudo resize2fs $PARTITION
sudo mount -o rw $PARTITION /mnt
sudo sed -i 's/^/#/g' /mnt/etc/ld.so.preload
sudo cp /usr/bin/qemu-arm-static /mnt/usr/bin/
sudo cp install.sh /mnt/tmp

sudo chroot /mnt /tmp/install.sh

sudo sed -i 's/^#//g' /mnt/etc/ld.so.preload

sudo umount /mnt
sudo losetup -d $LOOP_DEVICE
mv tmp/$EXISTING_RPIOS_IMG ../dists/retronas-$EXISTING_RPIOS_IMG
rm -rf tmp
