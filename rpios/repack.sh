#!/bin/bash

echo Copying image to temporary directory...
IMAGE=iso-cache/$EXISTING_RPIOS_IMG

DMNT=mnt
TDIR=tmp

if [ -f $IMAGE ]
then
  [ ! -d $TDIR ] && mkdir -p $TDIR
  [ ! -d $DMNT ] && mkdir -p $DMNT
  [ ! -f ${TDIR}/$(basename $IMAGE) ] && cp $IMAGE $TDIR

  echo Requesting root permission for setting up loop devices
  LOOP_DEVICE=$(sudo losetup -f)
  PARTITION="${LOOP_DEVICE}p2"
  echo Free loop device found: $LOOP_DEVICE

  # resize image
  dd if=/dev/zero bs=512 count=3276800 >> ${TDIR}/${EXISTING_RPIOS_IMG}
  sudo parted -s -a optimal -- ${TDIR}/${EXISTING_RPIOS_IMG} unit MB resizepart 2 -1

  sudo losetup $LOOP_DEVICE ${TDIR}/${EXISTING_RPIOS_IMG}
  sudo partx -a $LOOP_DEVICE

  sudo e2fsck -f $PARTITION
  sudo resize2fs $PARTITION

  sudo mount -o rw $PARTITION $DMNT

  #sudo sed -i 's/^/#/g' /mnt/etc/ld.so.preload
  sudo cp /usr/bin/qemu-aarch64-static ${DMNT}/usr/bin/
  sudo cp /usr/bin/qemu-arm-static ${DMNT}/usr/bin/
  
  sudo cp install.sh ${DMNT}/tmp
  sudo chroot ${DMNT} /tmp/install.sh
  #sudo sed -i 's/^#//g' /mnt/etc/ld.so.preload

  # add our retronas user
  export OLDRNUSER=retronas
  export RNPASSWD=retronas
  sudo chroot ${DMNT} useradd -m -s /bin/bash $OLDRNUSER
  echo "$OLDRNUSER ALL=(ALL) NOPASSWD:ALL" | sudo chroot ${DMNT} tee /etc/sudoers.d/${OLDRNUSER}
  sudo chroot ${DMNT} chmod 440 /etc/sudoers.d/${OLDRNUSER}
  echo -e "${RNPASSWD}\n${RNPASSWD}" | sudo chroot ${DMNT} passwd $OLDNUSER


  sudo rm -f ${DMNT}/usr/bin/qemu-*
  sudo umount ${DMNT}
  sudo losetup -d $LOOP_DEVICE

  #mv tmp/$EXISTING_RPIOS_IMG ../dists/retronas-$EXISTING_RPIOS_IMG
  #rm -rf tmp

else
  echo "No image file, Nothing to do"

fi
