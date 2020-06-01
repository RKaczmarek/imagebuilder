#!/bin/bash

MYTMPDIR="/tmp/r89-boot-tmp"

if [ "$#" = "0" ]; then
  echo ""
  echo "usage: $0 kernel-version"
  echo ""
  echo "example: $0 4.19.32-stb-av7+"
  echo ""
  exit 1
fi

export kver=$1

if [ ! -f ${MOUNT_POINT}/boot/zImage-${kver} ]; then
  echo ""
  echo "cannot find kernel image ${MOUNT_POINT}/boot/zImage-${kver} - giving up"
  echo ""
  exit 1
fi

if [ ! -f ${MOUNT_POINT}/boot/initrd.img-${kver} ]; then
  echo ""
  echo "cannot find initrd image ${MOUNT_POINT}/boot/initrd.img-${kver} - giving up"
  echo ""
  exit 1
fi

if [ ! -f ${MOUNT_POINT}/boot/dtb-${kver}/rk3288-r89.dtb ]; then
  echo ""
  echo "cannot find dtb file ${MOUNT_POINT}/boot/dtb-${kver}/rk3288-r89.dtb - giving up"
  echo ""
  exit 1
fi

rm ${MYTMPDIR}/*

# exit on error
set -e

mkdir -p ${MYTMPDIR}
echo "- creating kernel image"
${MOUNT_POINT}/boot/r89-boot/mkkrnlimg -a ${MOUNT_POINT}/boot/zImage-${kver} ${MYTMPDIR}/kernel-linux.img
cp ${MOUNT_POINT}/boot/initrd.img-${kver} ${MYTMPDIR}/initrd.img-${kver}.gz
gunzip ${MYTMPDIR}/initrd.img-${kver}.gz
echo "- creating initrd image"
${MOUNT_POINT}/boot/r89-boot/mkkrnlimg -a ${MYTMPDIR}/initrd.img-${kver} ${MYTMPDIR}/boot-linux.img
rm ${MYTMPDIR}/initrd.img-${kver}
cp ${MOUNT_POINT}/boot/dtb-${kver}/rk3288-r89.dtb ${MYTMPDIR}/rk-kernel.dtb
echo "- creating resource image"
( cd ${MYTMPDIR} && ${MOUNT_POINT}/boot/r89-boot/resource_tool rk-kernel.dtb && mv resource.img resource-linux.img )
rm ${MYTMPDIR}/rk-kernel.dtb
