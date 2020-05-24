#!/bin/bash

if [ "$#" != "3" ]; then
  echo ""
  echo "usage: $0 system arch ubuntu/debian"
  echo ""
  echo "possible system options:"
  echo "- chromebook_snow (armv7l)"
  echo "- chromebook_veyron (armv7l) (not yet implemented)"
  echo "- odroid_u3 (armv7l)"
  echo "- orbsmart_s92_beelink_r89 (armv7l)"
  echo "- tinkerboard (armv7l)"
  echo "- raspberry_pi (armv7l)"
  echo "- raspberry_pi (aarch64)"
  echo "- raspberry_pi_4 (armv7l) (not yet implemented)"
  echo "- raspberry_pi_4 (aarch64)"
  echo "- amlogic_gx (armv7l)"
  echo "- amlogic_gx (aarch64)"
  echo ""
  echo "possible arch options:"
  echo "- armv7l (32bit) userland"
  echo "- aarch64 (64bit) userland"
  echo ""
  echo "example: $0 odroid_u3 armv7l"
  echo ""
  exit 1
fi

TARGET_SYSTEM=$1
TARGET_ARCH=$2
TARGET_DIST=$3

cd `dirname $0`/..
export WORKDIR=`pwd`
export BUILD_ROOT=${WORKDIR}/build/imagebuilder-root

if [ -d ${BUILD_ROOT} ]; then
  echo ""
  echo "BUILD_ROOT ${BUILD_ROOT} alresdy exists - giving up for safety reasons ..."
  echo ""
  exit 1
fi

mkdir -p ${BUILD_ROOT}
cd ${BUILD_ROOT}

if [ "$TARGET_ARCH" = "armv7l" ]; then 
  BOOTSTRAP_ARCH=armhf
elif [ "${TARGET_ARCH}" = "aarch64" ]; then 
  BOOTSTRAP_ARCH=arm64
fi
if [ "${TARGET_DIST}" = "ubuntu" ]; then 
  LANG=C debootstrap --arch=${BOOTSTRAP_ARCH} focal ${BUILD_ROOT} http://ports.ubuntu.com/
elif [ "${TARGET_DIST}" = "debian" ]; then 
  LANG=C debootstrap --variant=minbase --arch=${BOOTSTRAP_ARCH} buster ${BUILD_ROOT} http://deb.debian.org/debian/
fi

cp ${WORKDIR}/files/${TARGET_DIST}-sources.list ${BUILD_ROOT}/etc/apt/sources.list
cp /etc/resolv.conf ${BUILD_ROOT}/etc/resolv.conf

mount -o bind /dev ${BUILD_ROOT}/dev
mount -o bind /dev/pts ${BUILD_ROOT}/dev/pts
mount -t sysfs /sys ${BUILD_ROOT}/sys
mount -t proc /proc ${BUILD_ROOT}/proc


chroot ${BUILD_ROOT} /create-chroot.sh ${TARGET_DIST}

cd ${BUILD_ROOT}/

tar --numeric-owner -xzf ${WORKDIR}/downloads/kernel-${TARGET_SYSTEM}-${TARGET_ARCH}.tar.gz ./boot -C ./boot
tar --numeric-owner -xzf ${WORKDIR}/downloads/kernel-${TARGET_SYSTEM}-${TARGET_ARCH}.tar.gz ./lib/* -C ./

if [ -f ${WORKDIR}/downloads/kernel-mali-${TARGET_SYSTEM}-${TARGET_ARCH}.tar.gz ]; then
  tar --numeric-owner -xzf ${WORKDIR}/downloads/kernel-mali-${TARGET_SYSTEM}-${TARGET_ARCH}.tar.gz
fi

rm -f create-chroot.sh
( cd ${WORKDIR}/files/extra-files ; tar cf - . ) | tar xf -
if [ -d ${WORKDIR}/files/extra-files-${TARGET_ARCH} ]; then
  ( cd ${WORKDIR}/files/extra-files-${TARGET_ARCH} ; tar cf - . ) | tar xf -
fi
if [ -d ${WORKDIR}/files/extra-files-${TARGET_DIST} ]; then
  ( cd ${WORKDIR}/files/extra-files-${TARGET_DIST} ; tar cf - . ) | tar xf -
fi
if [ -d ${WORKDIR}/files/systems/${TARGET_SYSTEM}/extra-files-${TARGET_SYSTEM}-${TARGET_ARCH} ]; then
  ( cd ${WORKDIR}/files/systems/${TARGET_SYSTEM}/extra-files-${TARGET_SYSTEM}-${TARGET_ARCH} ; tar cf - . ) | tar xf -
fi
if [ -d ${WORKDIR}/files/systems/${TARGET_SYSTEM}/extra-files-${TARGET_SYSTEM}-${TARGET_ARCH}-${TARGET_DIST} ]; then
  ( cd ${WORKDIR}/files/systems/${TARGET_SYSTEM}/extra-files-${TARGET_SYSTEM}-${TARGET_ARCH}-${TARGET_DIST} ; tar cf - . ) | tar xf -
fi
if [ -f ${WORKDIR}/downloads/opengl-${TARGET_SYSTEM}-${TARGET_ARCH}.tar.gz ]; then
  tar --numeric-owner -xzf ${WORKDIR}/downloads/opengl-${TARGET_SYSTEM}-${TARGET_ARCH}.tar.gz
fi
if [ -f ${WORKDIR}/downloads/opengl-fbdev-${TARGET_SYSTEM}-${TARGET_ARCH}.tar.gz ]; then
  tar --numeric-owner -xzf ${WORKDIR}/downloads/opengl-fbdev-${TARGET_SYSTEM}-${TARGET_ARCH}.tar.gz
fi
if [ -f ${WORKDIR}/downloads/opengl-wayland-${TARGET_SYSTEM}-${TARGET_ARCH}.tar.gz ]; then
  tar --numeric-owner -xzf ${WORKDIR}/downloads/opengl-wayland-${TARGET_SYSTEM}-${TARGET_ARCH}.tar.gz
fi
if [ -f ${WORKDIR}/downloads/opengl-rpi-${TARGET_ARCH}-${TARGET_DIST}.tar.gz ]; then
  tar --numeric-owner -xzf ${WORKDIR}/downloads/opengl-rpi-${TARGET_ARCH}-${TARGET_DIST}.tar.gz
fi
if [ -f ${WORKDIR}/downloads/xorg-armsoc-${TARGET_ARCH}-${TARGET_DIST}.tar.gz ]; then
  tar --numeric-owner -xzf ${WORKDIR}/downloads/xorg-armsoc-${TARGET_ARCH}-${TARGET_DIST}.tar.gz
fi
if [ -f ${WORKDIR}/downloads/gl4es-${TARGET_ARCH}-${TARGET_DIST}.tar.gz ]; then
  tar --numeric-owner -xzf ${WORKDIR}/downloads/gl4es-${TARGET_ARCH}-${TARGET_DIST}.tar.gz
fi
if [ -f ${WORKDIR}/files/systems/${TARGET_SYSTEM}/rc-local-additions-${TARGET_SYSTEM}-${TARGET_ARCH}-${TARGET_DIST}.txt ]; then
  echo "" >> etc/rc.local
  echo "# additions for ${TARGET_SYSTEM}-${TARGET_ARCH}-${TARGET_DIST}" >> etc/rc.local
  echo "" >> etc/rc.local
  cat ${WORKDIR}/files/systems/${TARGET_SYSTEM}/rc-local-additions-${TARGET_SYSTEM}-${TARGET_ARCH}-${TARGET_DIST}.txt >> etc/rc.local
fi
echo "" >> etc/rc.local
echo "exit 0" >> etc/rc.local

# adjust some config files if they exist
if [ -f ${BUILD_ROOT}/etc/modules-load.d/cups-filters.conf ]; then
  sed -i 's,^lp,#lp,g' ${BUILD_ROOT}/etc/modules-load.d/cups-filters.conf
  sed -i 's,^ppdev,#ppdev,g' ${BUILD_ROOT}/etc/modules-load.d/cups-filters.conf
  sed -i 's,^parport_pc,#parport_pc,g' ${BUILD_ROOT}/etc/modules-load.d/cups-filters.conf
fi
if [ -f ${BUILD_ROOT}/etc/NetworkManager/NetworkManager.conf ]; then
  sed -i 's,^managed=false,managed=true,g' ${BUILD_ROOT}/etc/NetworkManager/NetworkManager.conf
  touch ${BUILD_ROOT}/etc/NetworkManager/conf.d/10-globally-managed-devices.conf
fi
if [ -f ${BUILD_ROOT}/etc/default/numlockx ]; then
  sed -i 's,^NUMLOCK=auto,NUMLOCK=off,g' ${BUILD_ROOT}/etc/default/numlockx
fi

export KERNEL_VERSION=`ls ${BUILD_ROOT}/boot/*Image-* | sed 's,.*Image-,,g' | sort -u`

# hack to get the fsck binaries in properly even in our chroot env
cp -f ${BUILD_ROOT}/usr/share/initramfs-tools/hooks/fsck ${BUILD_ROOT}/tmp/fsck.org
sed -i 's,fsck_types=.*,fsck_types="vfat ext4",g' ${BUILD_ROOT}/usr/share/initramfs-tools/hooks/fsck
chroot ${BUILD_ROOT} update-initramfs -c -k ${KERNEL_VERSION}
mv -f ${BUILD_ROOT}/tmp/fsck.org ${BUILD_ROOT}/usr/share/initramfs-tools/hooks/fsck

cd ${BUILD_ROOT}

# post install script per system
if [ -x ${WORKDIR}/files/systems/${TARGET_SYSTEM}/postinstall-${TARGET_SYSTEM}-${TARGET_ARCH}-${TARGET_DIST}.sh ]; then
  ${WORKDIR}/files/systems/${TARGET_SYSTEM}/postinstall-${TARGET_SYSTEM}-${TARGET_ARCH}-${TARGET_DIST}.sh
fi

cd ${WORKDIR}

umount ${BUILD_ROOT}/proc ${BUILD_ROOT}/sys ${BUILD_ROOT}/dev/pts ${BUILD_ROOT}/dev

echo ""
echo "now run create-image.sh ${TARGET_SYSTEM} ${TARGET_ARCH} ${TARGET_DIST} to build the image"
echo ""
