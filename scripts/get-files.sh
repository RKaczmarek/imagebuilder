#!/bin/bash
#
# please run this script to fetch some large files from various github releases before starting to build images

if [ "$#" != "2" ]; then
  echo ""
  echo "usage: $0 system arch"
  echo ""
  echo "possible system options:"
  echo "               chromebook_snow (armv7l)"
  echo "               chromebook_veyron (armv7l)"
  echo "               chromebook_nyanbig (armv7l)"
  echo "               odroid_u3 (armv7l)"
  echo "               orbsmart_s92_beelink_r89 (armv7l)"
  echo "               tinkerboard (armv7l)"
  echo "               raspberry_pi (armv7l)"
  echo "               raspberry_pi (aarch64)"
  echo "               raspberry_pi_4 (armv7l) (using a 64bit kernel)"
  echo "               raspberry_pi_4 (aarch64)"
  echo "               amlogic_gx (armv7l) (using a 64bit kernel)"
  echo "               amlogic_gx (aarch64)"
  echo "               all (all)"
  echo ""
  echo "possible arch options:"
  echo "- armv7l (32bit) userland"
  echo "- aarch64 (64bit) userland"
  echo "- all (32bit and 64bit) userland"
  echo ""
  echo "examples: $0 odroid_u3 armv7l"
  echo "          $0 all all"
  echo ""
  exit 1
fi

cd `dirname $0`/..
WORKDIR=`pwd`
TARGET_SYSTEM=$1
TARGET_ARCH=$2

DOWNLOADS_DIR=${WORKDIR}/downloads

# create downloads dir
mkdir ${DOWNLOADS_DIR}

# exit on errors
set -e

generic_tree_tag="9051dfe1f2198e2ed41c322359ee8324043d55a9"

chromebook_snow_release_version="5.4.14-stb-cbe%2B"
chromebook_snow_uboot_version="v2020.04-cbe"
chromebook_snow_generic_tree_tag=${generic_tree_tag}

chromebook_veyron_release_version="5.4.31-stb-cbr%2B"
chromebook_veyron_uboot_version="v2020.04-cbr"
chromebook_veyron_generic_tree_tag=${generic_tree_tag}

chromebook_nyanbig_release_version="5.4.35-ntg-cbt%2B"
chromebook_nyanbig_uboot_version="v2018.11-cbt"
chromebook_nyanbig_generic_tree_tag=${generic_tree_tag}
chromebook_nyanbig_mesa_release_version="20.0.6"

odroid_u3_release_version="5.4.20-stb-exy%2B-20200515-0233"
odroid_u3_generic_tree_tag=${generic_tree_tag}

orbsmart_s92_beelink_r89_release_version="5.4.14-stb-av7%2B"
orbsmart_s92_beelink_r89_generic_tree_tag=${generic_tree_tag}

tinkerboard_release_version="5.4.14-stb-av7%2B"
tinkerboard_generic_tree_tag=${generic_tree_tag}

raspberry_pi_armv7l_release_version="5.4.14-stb-av7%2B"
raspberry_pi_armv7l_generic_tree_tag=${generic_tree_tag}
raspberry_pi_armv7l_mesa_release_version="20.0.6"

raspberry_pi_aarch64_release_version="5.4.14-stb-av8%2B"
raspberry_pi_aarch64_generic_tree_tag=${generic_tree_tag}
raspberry_pi_aarch64_mesa_release_version="20.0.6"

raspberry_pi_4_armv7l_release_version="5.6.10-rpi-64b%2B"
raspberry_pi_4_armv7l_generic_tree_tag=${generic_tree_tag}
raspberry_pi_4_armv7l_mesa_release_version="20.0.6"

raspberry_pi_4_aarch64_release_version="5.6.10-rpi-64b%2B"
raspberry_pi_4_aarch64_generic_tree_tag=${generic_tree_tag}
raspberry_pi_4_aarch64_mesa_release_version="20.0.6"

amlogic_gx_release_version="5.4.14-stb-av8%2B"
amlogic_gx_generic_tree_tag=${generic_tree_tag}

if ([ "${TARGET_SYSTEM}" = "all" ] || [ "${TARGET_SYSTEM}" = "chromebook_snow" ]) && [ "${TARGET_ARCH}" = "armv7l" ]; then
  rm -f ${DOWNLOADS_DIR}/kernel-chromebook_snow-armv7l.tar.gz
  wget -v https://github.com/hexdump0815/linux-mainline-and-mali-generic-stable-kernel/releases/download/${chromebook_snow_release_version}/${chromebook_snow_release_version}.tar.gz -O ${DOWNLOADS_DIR}/kernel-chromebook_snow-armv7l.tar.gz
  rm -f ${DOWNLOADS_DIR}/boot-chromebook_snow-armv7l.dd
  # we assemble the bootblocks from a prepared chromebook partition table and the proper u-boot kpart image
  cp files/chromebook-boot/cb.dd-single-part ${DOWNLOADS_DIR}/boot-chromebook_snow-armv7l.dd
  wget -v https://github.com/hexdump0815/u-boot-chainloading-for-arm-chromebooks/releases/download/${chromebook_snow_uboot_version}/uboot.kpart.cbe.gz -O - | gunzip -c >> ${DOWNLOADS_DIR}/boot-chromebook_snow-armv7l.dd
  rm -f ${DOWNLOADS_DIR}/gl4es-armv7l-debian.tar.gz
  wget -v https://github.com/hexdump0815/linux-mainline-and-mali-generic-stable-kernel/raw/${chromebook_snow_generic_tree_tag}/misc/gl4es-armv7l-debian.tar.gz -O ${DOWNLOADS_DIR}/gl4es-armv7l-debian.tar.gz
  rm -f ${DOWNLOADS_DIR}/gl4es-armv7l-ubuntu.tar.gz
  wget -v https://github.com/hexdump0815/linux-mainline-and-mali-generic-stable-kernel/raw/${chromebook_snow_generic_tree_tag}/misc/gl4es-armv7l-ubuntu.tar.gz -O ${DOWNLOADS_DIR}/gl4es-armv7l-ubuntu.tar.gz
  rm -f ${DOWNLOADS_DIR}/xorg-armsoc-armv7l-debian.tar.gz
  wget -v https://github.com/hexdump0815/linux-mainline-and-mali-generic-stable-kernel/raw/${chromebook_snow_generic_tree_tag}/misc/xorg-armsoc-armv7l-debian.tar.gz -O ${DOWNLOADS_DIR}/xorg-armsoc-armv7l-debian.tar.gz
  rm -f ${DOWNLOADS_DIR}/xorg-armsoc-armv7l-ubuntu.tar.gz
  wget -v https://github.com/hexdump0815/linux-mainline-and-mali-generic-stable-kernel/raw/${chromebook_snow_generic_tree_tag}/misc/xorg-armsoc-armv7l-ubuntu.tar.gz -O ${DOWNLOADS_DIR}/xorg-armsoc-armv7l-ubuntu.tar.gz
  rm -f ${DOWNLOADS_DIR}/opengl-chromebook_snow-armv7l.tar.gz
  wget -v https://github.com/hexdump0815/linux-mainline-and-mali-generic-stable-kernel/raw/${chromebook_snow_generic_tree_tag}/misc/opt-mali-exynos5250-armv7l.tar.gz -O ${DOWNLOADS_DIR}/opengl-chromebook_snow-armv7l.tar.gz
  rm -f ${DOWNLOADS_DIR}/opengl-fbdev-chromebook_snow-armv7l.tar.gz
  wget -v https://github.com/hexdump0815/linux-mainline-and-mali-generic-stable-kernel/raw/${chromebook_snow_generic_tree_tag}/misc/opt-mali-exynos5250-fbdev-r5p0-armv7l.tar.gz -O ${DOWNLOADS_DIR}/opengl-fbdev-chromebook_snow-armv7l.tar.gz
fi

if ([ "${TARGET_SYSTEM}" = "all" ] || [ "${TARGET_SYSTEM}" = "chromebook_veyron" ]) && [ "${TARGET_ARCH}" = "armv7l" ]; then
  rm -f ${DOWNLOADS_DIR}/kernel-chromebook_veyron-armv7l.tar.gz
  wget -v https://github.com/hexdump0815/linux-mainline-and-mali-generic-stable-kernel/releases/download/${chromebook_veyron_release_version}/${chromebook_veyron_release_version}.tar.gz -O ${DOWNLOADS_DIR}/kernel-chromebook_veyron-armv7l.tar.gz
  rm -f ${DOWNLOADS_DIR}/boot-chromebook_veyron-armv7l.dd
  # we assemble the bootblocks from a prepared chromebook partition table and the proper u-boot kpart image
  cp files/chromebook-boot/cb.dd-single-part ${DOWNLOADS_DIR}/boot-chromebook_veyron-armv7l.dd
  wget -v https://github.com/hexdump0815/u-boot-chainloading-for-arm-chromebooks/releases/download/${chromebook_veyron_uboot_version}/uboot.kpart.cbr.gz -O - | gunzip -c >> ${DOWNLOADS_DIR}/boot-chromebook_veyron-armv7l.dd
  rm -f ${DOWNLOADS_DIR}/gl4es-armv7l-debian.tar.gz
  wget -v https://github.com/hexdump0815/linux-mainline-and-mali-generic-stable-kernel/raw/${chromebook_veyron_generic_tree_tag}/misc/gl4es-armv7l-debian.tar.gz -O ${DOWNLOADS_DIR}/gl4es-armv7l-debian.tar.gz
  rm -f ${DOWNLOADS_DIR}/gl4es-armv7l-ubuntu.tar.gz
  wget -v https://github.com/hexdump0815/linux-mainline-and-mali-generic-stable-kernel/raw/${chromebook_veyron_generic_tree_tag}/misc/gl4es-armv7l-ubuntu.tar.gz -O ${DOWNLOADS_DIR}/gl4es-armv7l-ubuntu.tar.gz
  rm -f ${DOWNLOADS_DIR}/xorg-armsoc-armv7l-debian.tar.gz
  wget -v https://github.com/hexdump0815/linux-mainline-and-mali-generic-stable-kernel/raw/${chromebook_veyron_generic_tree_tag}/misc/xorg-armsoc-armv7l-debian.tar.gz -O ${DOWNLOADS_DIR}/xorg-armsoc-armv7l-debian.tar.gz
  rm -f ${DOWNLOADS_DIR}/xorg-armsoc-armv7l-ubuntu.tar.gz
  wget -v https://github.com/hexdump0815/linux-mainline-and-mali-generic-stable-kernel/raw/${chromebook_veyron_generic_tree_tag}/misc/xorg-armsoc-armv7l-ubuntu.tar.gz -O ${DOWNLOADS_DIR}/xorg-armsoc-armv7l-ubuntu.tar.gz
  rm -f ${DOWNLOADS_DIR}/opengl-chromebook_veyron-armv7l.tar.gz
  wget -v https://github.com/hexdump0815/linux-mainline-and-mali-generic-stable-kernel/raw/${chromebook_veyron_generic_tree_tag}/misc/opt-mali-rk3288-armv7l.tar.gz -O ${DOWNLOADS_DIR}/opengl-chromebook_veyron-armv7l.tar.gz
  rm -f ${DOWNLOADS_DIR}/opengl-fbdev-chromebook_veyron-armv7l.tar.gz
  wget -v https://github.com/hexdump0815/linux-mainline-and-mali-generic-stable-kernel/raw/${chromebook_veyron_generic_tree_tag}/misc/opt-mali-rk3288-fbdev-armv7l.tar.gz -O ${DOWNLOADS_DIR}/opengl-fbdev-chromebook_veyron-armv7l.tar.gz
  rm -f ${DOWNLOADS_DIR}/opengl-wayland-chromebook_veyron-armv7l.tar.gz
  wget -v https://github.com/hexdump0815/linux-mainline-and-mali-generic-stable-kernel/raw/${chromebook_veyron_generic_tree_tag}/misc/opt-mali-rk3288-wayland-armv7l.tar.gz -O ${DOWNLOADS_DIR}/opengl-wayland-chromebook_veyron-armv7l.tar.gz
fi

if ([ "${TARGET_SYSTEM}" = "all" ] || [ "${TARGET_SYSTEM}" = "chromebook_nyanbig" ]) && [ "${TARGET_ARCH}" = "armv7l" ]; then
  rm -f ${DOWNLOADS_DIR}/kernel-chromebook_nyanbig-armv7l.tar.gz
  wget -v https://github.com/hexdump0815/linux-mainline-tegra-k1-kernel/releases/download/${chromebook_nyanbig_release_version}/${chromebook_nyanbig_release_version}.tar.gz -O ${DOWNLOADS_DIR}/kernel-chromebook_nyanbig-armv7l.tar.gz
  rm -f ${DOWNLOADS_DIR}/boot-chromebook_nyanbig-armv7l.dd
  # we assemble the bootblocks from a prepared chromebook partition table and the proper u-boot kpart image
  cp files/chromebook-boot/cb.dd-single-part ${DOWNLOADS_DIR}/boot-chromebook_nyanbig-armv7l.dd
  wget -v https://github.com/hexdump0815/u-boot-chainloading-for-arm-chromebooks/releases/download/${chromebook_nyanbig_uboot_version}/uboot.kpart.cbt.gz -O - | gunzip -c >> ${DOWNLOADS_DIR}/boot-chromebook_nyanbig-armv7l.dd
  rm -f ${DOWNLOADS_DIR}/gl4es-armv7l-debian.tar.gz
  wget -v https://github.com/hexdump0815/linux-mainline-and-mali-generic-stable-kernel/raw/${chromebook_nyanbig_generic_tree_tag}/misc/gl4es-armv7l-debian.tar.gz -O ${DOWNLOADS_DIR}/gl4es-armv7l-debian.tar.gz
  rm -f ${DOWNLOADS_DIR}/gl4es-armv7l-ubuntu.tar.gz
  wget -v https://github.com/hexdump0815/linux-mainline-and-mali-generic-stable-kernel/raw/${chromebook_nyanbig_generic_tree_tag}/misc/gl4es-armv7l-ubuntu.tar.gz -O ${DOWNLOADS_DIR}/gl4es-armv7l-ubuntu.tar.gz
  rm -f ${DOWNLOADS_DIR}/opengl-mesa-armv7l-debian.tar.gz
  wget -v https://github.com/hexdump0815/mesa-etc-build/releases/download/${chromebook_nyanbig_mesa_release_version}/opt-mesa-armv7l-debian.tar.gz -O ${DOWNLOADS_DIR}/opengl-mesa-armv7l-debian.tar.gz
  rm -f ${DOWNLOADS_DIR}/opengl-mesa-armv7l-ubuntu.tar.gz
  wget -v https://github.com/hexdump0815/mesa-etc-build/releases/download/${chromebook_nyanbig_mesa_release_version}/opt-mesa-armv7l-ubuntu.tar.gz -O ${DOWNLOADS_DIR}/opengl-mesa-armv7l-ubuntu.tar.gz
fi

if ([ "${TARGET_SYSTEM}" = "all" ] || [ "${TARGET_SYSTEM}" = "odroid_u3" ]) && [ "${TARGET_ARCH}" = "armv7l" ]; then
  rm -f ${DOWNLOADS_DIR}/kernel-odroid_u3-armv7l.tar.gz
  wget -v https://github.com/RKaczmarek/kernel-odroid-u3/releases/download/${odroid_u3_release_version}-active/${odroid_u3_release_version}.tar.gz -O ${DOWNLOADS_DIR}/kernel-odroid_u3-armv7l.tar.gz
  rm -f ${DOWNLOADS_DIR}/boot-odroid_u3-armv7l.dd
  wget -v https://github.com/hexdump0815/linux-mainline-and-mali-generic-stable-kernel/raw/${odroid_u3_generic_tree_tag}/misc.exy/u-boot/boot-odroid_u3-armv7l.dd -O ${DOWNLOADS_DIR}/boot-odroid_u3-armv7l.dd
  rm -f ${DOWNLOADS_DIR}/gl4es-armv7l-debian.tar.gz
  wget -v https://github.com/hexdump0815/linux-mainline-and-mali-generic-stable-kernel/raw/${odroid_u3_generic_tree_tag}/misc/gl4es-armv7l-debian.tar.gz -O ${DOWNLOADS_DIR}/gl4es-armv7l-debian.tar.gz
  rm -f ${DOWNLOADS_DIR}/gl4es-armv7l-ubuntu.tar.gz
  wget -v https://github.com/hexdump0815/linux-mainline-and-mali-generic-stable-kernel/raw/${odroid_u3_generic_tree_tag}/misc/gl4es-armv7l-ubuntu.tar.gz -O ${DOWNLOADS_DIR}/gl4es-armv7l-ubuntu.tar.gz
  rm -f ${DOWNLOADS_DIR}/xorg-armsoc-armv7l-debian.tar.gz
  wget -v https://github.com/hexdump0815/linux-mainline-and-mali-generic-stable-kernel/raw/${odroid_u3_generic_tree_tag}/misc/xorg-armsoc-armv7l-debian.tar.gz -O ${DOWNLOADS_DIR}/xorg-armsoc-armv7l-debian.tar.gz
  rm -f ${DOWNLOADS_DIR}/xorg-armsoc-armv7l-ubuntu.tar.gz
  wget -v https://github.com/hexdump0815/linux-mainline-and-mali-generic-stable-kernel/raw/${odroid_u3_generic_tree_tag}/misc/xorg-armsoc-armv7l-ubuntu.tar.gz -O ${DOWNLOADS_DIR}/xorg-armsoc-armv7l-ubuntu.tar.gz
  rm -f ${DOWNLOADS_DIR}/opengl-odroid_u3-armv7l.tar.gz
  wget -v https://github.com/hexdump0815/linux-mainline-and-mali-generic-stable-kernel/raw/${odroid_u3_generic_tree_tag}/misc/opt-mali-exynos4412-armv7l.tar.gz -O ${DOWNLOADS_DIR}/opengl-odroid_u3-armv7l.tar.gz
  rm -f ${DOWNLOADS_DIR}/opengl-fbdev-odroid_u3-armv7l.tar.gz
  wget -v https://github.com/hexdump0815/linux-mainline-and-mali-generic-stable-kernel/raw/${odroid_u3_generic_tree_tag}/misc/opt-mali-exynos4412-fbdev-armv7l.tar.gz -O ${DOWNLOADS_DIR}/opengl-fbdev-odroid_u3-armv7l.tar.gz
fi

if ([ "${TARGET_SYSTEM}" = "all" ] || [ "${TARGET_SYSTEM}" = "orbsmart_s92_beelink_r89" ]) && [ "${TARGET_ARCH}" = "armv7l" ]; then
  rm -f ${DOWNLOADS_DIR}/kernel-orbsmart_s92_beelink_r89-armv7l.tar.gz
  wget -v https://github.com/hexdump0815/linux-mainline-and-mali-generic-stable-kernel/releases/download/${orbsmart_s92_beelink_r89_release_version}/${orbsmart_s92_beelink_r89_release_version}.tar.gz -O ${DOWNLOADS_DIR}/kernel-orbsmart_s92_beelink_r89-armv7l.tar.gz
  rm -f ${DOWNLOADS_DIR}/kernel-mali-orbsmart_s92_beelink_r89-armv7l.tar.gz
  wget -v https://github.com/hexdump0815/linux-mainline-and-mali-generic-stable-kernel/releases/download/${orbsmart_s92_beelink_r89_release_version}/${orbsmart_s92_beelink_r89_release_version}-mali-rk3288.tar.gz -O ${DOWNLOADS_DIR}/kernel-mali-orbsmart_s92_beelink_r89-armv7l.tar.gz
  rm -f ${DOWNLOADS_DIR}/gl4es-armv7l-debian.tar.gz
  wget -v https://github.com/hexdump0815/linux-mainline-and-mali-generic-stable-kernel/raw/${orbsmart_s92_beelink_r89_generic_tree_tag}/misc/gl4es-armv7l-debian.tar.gz -O ${DOWNLOADS_DIR}/gl4es-armv7l-debian.tar.gz
  rm -f ${DOWNLOADS_DIR}/gl4es-armv7l-ubuntu.tar.gz
  wget -v https://github.com/hexdump0815/linux-mainline-and-mali-generic-stable-kernel/raw/${orbsmart_s92_beelink_r89_generic_tree_tag}/misc/gl4es-armv7l-ubuntu.tar.gz -O ${DOWNLOADS_DIR}/gl4es-armv7l-ubuntu.tar.gz
  rm -f ${DOWNLOADS_DIR}/xorg-armsoc-armv7l-debian.tar.gz
  wget -v https://github.com/hexdump0815/linux-mainline-and-mali-generic-stable-kernel/raw/${orbsmart_s92_beelink_r89_generic_tree_tag}/misc/xorg-armsoc-armv7l-debian.tar.gz -O ${DOWNLOADS_DIR}/xorg-armsoc-armv7l-debian.tar.gz
  rm -f ${DOWNLOADS_DIR}/xorg-armsoc-armv7l-ubuntu.tar.gz
  wget -v https://github.com/hexdump0815/linux-mainline-and-mali-generic-stable-kernel/raw/${orbsmart_s92_beelink_r89_generic_tree_tag}/misc/xorg-armsoc-armv7l-ubuntu.tar.gz -O ${DOWNLOADS_DIR}/xorg-armsoc-armv7l-ubuntu.tar.gz
  rm -f ${DOWNLOADS_DIR}/opengl-orbsmart_s92_beelink_r89-armv7l.tar.gz
  wget -v https://github.com/hexdump0815/linux-mainline-and-mali-generic-stable-kernel/raw/${orbsmart_s92_beelink_r89_generic_tree_tag}/misc/opt-mali-rk3288-armv7l.tar.gz -O ${DOWNLOADS_DIR}/opengl-orbsmart_s92_beelink_r89-armv7l.tar.gz
  rm -f ${DOWNLOADS_DIR}/opengl-fbdev-orbsmart_s92_beelink_r89-armv7l.tar.gz
  wget -v https://github.com/hexdump0815/linux-mainline-and-mali-generic-stable-kernel/raw/${orbsmart_s92_beelink_r89_generic_tree_tag}/misc/opt-mali-rk3288-fbdev-armv7l.tar.gz -O ${DOWNLOADS_DIR}/opengl-fbdev-orbsmart_s92_beelink_r89-armv7l.tar.gz
  rm -f ${DOWNLOADS_DIR}/opengl-wayland-orbsmart_s92_beelink_r89-armv7l.tar.gz
  wget -v https://github.com/hexdump0815/linux-mainline-and-mali-generic-stable-kernel/raw/${orbsmart_s92_beelink_r89_generic_tree_tag}/misc/opt-mali-rk3288-wayland-armv7l.tar.gz -O ${DOWNLOADS_DIR}/opengl-wayland-orbsmart_s92_beelink_r89-armv7l.tar.gz
fi

if ([ "${TARGET_SYSTEM}" = "all" ] || [ "${TARGET_SYSTEM}" = "tinkerboard" ]) && [ "${TARGET_ARCH}" = "armv7l" ]; then
  rm -f ${DOWNLOADS_DIR}/kernel-tinkerboard-armv7l.tar.gz
  wget -v https://github.com/hexdump0815/linux-mainline-and-mali-generic-stable-kernel/releases/download/${tinkerboard_release_version}/${tinkerboard_release_version}.tar.gz -O ${DOWNLOADS_DIR}/kernel-tinkerboard-armv7l.tar.gz
  rm -f ${DOWNLOADS_DIR}/kernel-mali-tinkerboard-armv7l.tar.gz
  wget -v https://github.com/hexdump0815/linux-mainline-and-mali-generic-stable-kernel/releases/download/${tinkerboard_release_version}/${tinkerboard_release_version}-mali-rk3288.tar.gz -O ${DOWNLOADS_DIR}/kernel-mali-tinkerboard-armv7l.tar.gz
  rm -f ${DOWNLOADS_DIR}/boot-tinkerboard-armv7l.dd
  wget -v https://github.com/hexdump0815/linux-mainline-and-mali-generic-stable-kernel/raw/${tinkerboard_generic_tree_tag}/misc.av7/u-boot/boot-tinkerboard-armv7l.dd -O ${DOWNLOADS_DIR}/boot-tinkerboard-armv7l.dd
  rm -f ${DOWNLOADS_DIR}/gl4es-armv7l-debian.tar.gz
  wget -v https://github.com/hexdump0815/linux-mainline-and-mali-generic-stable-kernel/raw/${tinkerboard_generic_tree_tag}/misc/gl4es-armv7l-debian.tar.gz -O ${DOWNLOADS_DIR}/gl4es-armv7l-debian.tar.gz
  rm -f ${DOWNLOADS_DIR}/gl4es-armv7l-ubuntu.tar.gz
  wget -v https://github.com/hexdump0815/linux-mainline-and-mali-generic-stable-kernel/raw/${tinkerboard_generic_tree_tag}/misc/gl4es-armv7l-ubuntu.tar.gz -O ${DOWNLOADS_DIR}/gl4es-armv7l-ubuntu.tar.gz
  rm -f ${DOWNLOADS_DIR}/xorg-armsoc-armv7l-debian.tar.gz
  wget -v https://github.com/hexdump0815/linux-mainline-and-mali-generic-stable-kernel/raw/${tinkerboard_generic_tree_tag}/misc/xorg-armsoc-armv7l-debian.tar.gz -O ${DOWNLOADS_DIR}/xorg-armsoc-armv7l-debian.tar.gz
  rm -f ${DOWNLOADS_DIR}/xorg-armsoc-armv7l-ubuntu.tar.gz
  wget -v https://github.com/hexdump0815/linux-mainline-and-mali-generic-stable-kernel/raw/${tinkerboard_generic_tree_tag}/misc/xorg-armsoc-armv7l-ubuntu.tar.gz -O ${DOWNLOADS_DIR}/xorg-armsoc-armv7l-ubuntu.tar.gz
  rm -f ${DOWNLOADS_DIR}/opengl-tinkerboard-armv7l.tar.gz
  wget -v https://github.com/hexdump0815/linux-mainline-and-mali-generic-stable-kernel/raw/${tinkerboard_generic_tree_tag}/misc/opt-mali-rk3288-armv7l.tar.gz -O ${DOWNLOADS_DIR}/opengl-tinkerboard-armv7l.tar.gz
  rm -f ${DOWNLOADS_DIR}/opengl-fbdev-tinkerboard-armv7l.tar.gz
  wget -v https://github.com/hexdump0815/linux-mainline-and-mali-generic-stable-kernel/raw/${tinkerboard_generic_tree_tag}/misc/opt-mali-rk3288-fbdev-armv7l.tar.gz -O ${DOWNLOADS_DIR}/opengl-fbdev-tinkerboard-armv7l.tar.gz
  rm -f ${DOWNLOADS_DIR}/opengl-wayland-tinkerboard-armv7l.tar.gz
  wget -v https://github.com/hexdump0815/linux-mainline-and-mali-generic-stable-kernel/raw/${tinkerboard_generic_tree_tag}/misc/opt-mali-rk3288-wayland-armv7l.tar.gz -O ${DOWNLOADS_DIR}/opengl-wayland-tinkerboard-armv7l.tar.gz
fi

if ([ "${TARGET_SYSTEM}" = "all" ] || [ "${TARGET_SYSTEM}" = "raspberry_pi" ]) && [ "${TARGET_ARCH}" = "armv7l" ]; then
  rm -f ${DOWNLOADS_DIR}/kernel-raspberry_pi-armv7l.tar.gz
  wget -v https://github.com/hexdump0815/linux-mainline-and-mali-generic-stable-kernel/releases/download/${raspberry_pi_armv7l_release_version}/${raspberry_pi_armv7l_release_version}.tar.gz -O ${DOWNLOADS_DIR}/kernel-raspberry_pi-armv7l.tar.gz
  rm -f ${DOWNLOADS_DIR}/gl4es-armv7l-debian.tar.gz
  wget -v https://github.com/hexdump0815/linux-mainline-and-mali-generic-stable-kernel/raw/${raspberry_pi_armv7l_generic_tree_tag}/misc/gl4es-armv7l-debian.tar.gz -O ${DOWNLOADS_DIR}/gl4es-armv7l-debian.tar.gz
  rm -f ${DOWNLOADS_DIR}/gl4es-armv7l-ubuntu.tar.gz
  wget -v https://github.com/hexdump0815/linux-mainline-and-mali-generic-stable-kernel/raw/${raspberry_pi_armv7l_generic_tree_tag}/misc/gl4es-armv7l-ubuntu.tar.gz -O ${DOWNLOADS_DIR}/gl4es-armv7l-ubuntu.tar.gz
  rm -f ${DOWNLOADS_DIR}/opengl-mesa-armv7l-debian.tar.gz
  wget -v https://github.com/hexdump0815/mesa-etc-build/releases/download/${raspberry_pi_armv7l_mesa_release_version}/opt-mesa-armv7l-debian.tar.gz -O ${DOWNLOADS_DIR}/opengl-mesa-armv7l-debian.tar.gz
  rm -f ${DOWNLOADS_DIR}/opengl-mesa-armv7l-ubuntu.tar.gz
  wget -v https://github.com/hexdump0815/mesa-etc-build/releases/download/${raspberry_pi_armv7l_mesa_release_version}/opt-mesa-armv7l-ubuntu.tar.gz -O ${DOWNLOADS_DIR}/opengl-mesa-armv7l-ubuntu.tar.gz
fi

if ([ "${TARGET_SYSTEM}" = "all" ] || [ "${TARGET_SYSTEM}" = "raspberry_pi" ]) && [ "${TARGET_ARCH}" = "aarch64" ]; then
  rm -f ${DOWNLOADS_DIR}/kernel-raspberry_pi-aarch64.tar.gz
  wget -v https://github.com/hexdump0815/linux-mainline-and-mali-generic-stable-kernel/releases/download/${raspberry_pi_aarch64_release_version}/${raspberry_pi_aarch64_release_version}.tar.gz -O ${DOWNLOADS_DIR}/kernel-raspberry_pi-aarch64.tar.gz
  rm -f ${DOWNLOADS_DIR}/gl4es-aarch64-debian.tar.gz
  wget -v https://github.com/hexdump0815/linux-mainline-and-mali-generic-stable-kernel/raw/${raspberry_pi_aarch64_generic_tree_tag}/misc/gl4es-aarch64-debian.tar.gz -O ${DOWNLOADS_DIR}/gl4es-aarch64-debian.tar.gz
  rm -f ${DOWNLOADS_DIR}/gl4es-aarch64-ubuntu.tar.gz
  wget -v https://github.com/hexdump0815/linux-mainline-and-mali-generic-stable-kernel/raw/${raspberry_pi_aarch64_generic_tree_tag}/misc/gl4es-aarch64-ubuntu.tar.gz -O ${DOWNLOADS_DIR}/gl4es-aarch64-ubuntu.tar.gz
  rm -f ${DOWNLOADS_DIR}/opengl-mesa-aarch64-debian.tar.gz
  wget -v https://github.com/hexdump0815/mesa-etc-build/releases/download/${raspberry_pi_aarch64_mesa_release_version}/opt-mesa-aarch64-debian.tar.gz -O ${DOWNLOADS_DIR}/opengl-mesa-aarch64-debian.tar.gz
  rm -f ${DOWNLOADS_DIR}/opengl-mesa-aarch64-ubuntu.tar.gz
  wget -v https://github.com/hexdump0815/mesa-etc-build/releases/download/${raspberry_pi_aarch64_mesa_release_version}/opt-mesa-aarch64-ubuntu.tar.gz -O ${DOWNLOADS_DIR}/opengl-mesa-aarch64-ubuntu.tar.gz
fi

if ([ "${TARGET_SYSTEM}" = "all" ] || [ "${TARGET_SYSTEM}" = "raspberry_pi_4" ]) && [ "${TARGET_ARCH}" = "armv7l" ]; then
  rm -f ${DOWNLOADS_DIR}/kernel-raspberry_pi_4-armv7l.tar.gz
  wget -v https://github.com/hexdump0815/linux-raspberry-pi-4-kernel/releases/download/${raspberry_pi_4_armv7l_release_version}/${raspberry_pi_4_armv7l_release_version}.tar.gz -O ${DOWNLOADS_DIR}/kernel-raspberry_pi_4-armv7l.tar.gz
  rm -f ${DOWNLOADS_DIR}/gl4es-armv7l-debian.tar.gz
  wget -v https://github.com/hexdump0815/linux-mainline-and-mali-generic-stable-kernel/raw/${raspberry_pi_4_armv7l_generic_tree_tag}/misc/gl4es-armv7l-debian.tar.gz -O ${DOWNLOADS_DIR}/gl4es-armv7l-debian.tar.gz
  rm -f ${DOWNLOADS_DIR}/gl4es-armv7l-ubuntu.tar.gz
  wget -v https://github.com/hexdump0815/linux-mainline-and-mali-generic-stable-kernel/raw/${raspberry_pi_4_armv7l_generic_tree_tag}/misc/gl4es-armv7l-ubuntu.tar.gz -O ${DOWNLOADS_DIR}/gl4es-armv7l-ubuntu.tar.gz
  rm -f ${DOWNLOADS_DIR}/opengl-mesa-armv7l-debian.tar.gz
  wget -v https://github.com/hexdump0815/mesa-etc-build/releases/download/${raspberry_pi_4_armv7l_mesa_release_version}/opt-mesa-armv7l-debian.tar.gz -O ${DOWNLOADS_DIR}/opengl-mesa-armv7l-debian.tar.gz
  rm -f ${DOWNLOADS_DIR}/opengl-mesa-armv7l-ubuntu.tar.gz
  wget -v https://github.com/hexdump0815/mesa-etc-build/releases/download/${raspberry_pi_4_armv7l_mesa_release_version}/opt-mesa-armv7l-ubuntu.tar.gz -O ${DOWNLOADS_DIR}/opengl-mesa-armv7l-ubuntu.tar.gz
fi

if ([ "${TARGET_SYSTEM}" = "all" ] || [ "${TARGET_SYSTEM}" = "raspberry_pi_4" ]) && [ "${TARGET_ARCH}" = "aarch64" ]; then
  rm -f ${DOWNLOADS_DIR}/kernel-raspberry_pi_4-aarch64.tar.gz
  wget -v https://github.com/hexdump0815/linux-raspberry-pi-4-kernel/releases/download/${raspberry_pi_4_aarch64_release_version}/${raspberry_pi_4_aarch64_release_version}.tar.gz -O ${DOWNLOADS_DIR}/kernel-raspberry_pi_4-aarch64.tar.gz
  rm -f ${DOWNLOADS_DIR}/gl4es-aarch64-debian.tar.gz
  wget -v https://github.com/hexdump0815/linux-mainline-and-mali-generic-stable-kernel/raw/${raspberry_pi_4_aarch64_generic_tree_tag}/misc/gl4es-aarch64-debian.tar.gz -O ${DOWNLOADS_DIR}/gl4es-aarch64-debian.tar.gz
  rm -f ${DOWNLOADS_DIR}/gl4es-aarch64-ubuntu.tar.gz
  wget -v https://github.com/hexdump0815/linux-mainline-and-mali-generic-stable-kernel/raw/${raspberry_pi_4_aarch64_generic_tree_tag}/misc/gl4es-aarch64-ubuntu.tar.gz -O ${DOWNLOADS_DIR}/gl4es-aarch64-ubuntu.tar.gz
  rm -f ${DOWNLOADS_DIR}/opengl-mesa-aarch64-debian.tar.gz
  wget -v https://github.com/hexdump0815/mesa-etc-build/releases/download/${raspberry_pi_4_aarch64_mesa_release_version}/opt-mesa-aarch64-debian.tar.gz -O ${DOWNLOADS_DIR}/opengl-mesa-aarch64-debian.tar.gz
  rm -f ${DOWNLOADS_DIR}/opengl-mesa-aarch64-ubuntu.tar.gz
  wget -v https://github.com/hexdump0815/mesa-etc-build/releases/download/${raspberry_pi_4_aarch64_mesa_release_version}/opt-mesa-aarch64-ubuntu.tar.gz -O ${DOWNLOADS_DIR}/opengl-mesa-aarch64-ubuntu.tar.gz
fi

if ([ "${TARGET_SYSTEM}" = "all" ] || [ "${TARGET_SYSTEM}" = "amlogic_gx" ]) && [ "${TARGET_ARCH}" = "armv7l" ]; then
  rm -f ${DOWNLOADS_DIR}/kernel-amlogic_gx_armv7l-armv7l.tar.gz
  wget -v https://github.com/hexdump0815/linux-mainline-and-mali-generic-stable-kernel/releases/download/${amlogic_gx_release_version}/${amlogic_gx_release_version}.tar.gz -O ${DOWNLOADS_DIR}/kernel-amlogic_gx-armv7l.tar.gz
  rm -f ${DOWNLOADS_DIR}/kernel-mali-amlogic_gx_armv7l-armv7l.tar.gz
  wget -v https://github.com/hexdump0815/linux-mainline-and-mali-generic-stable-kernel/releases/download/${amlogic_gx_release_version}/${amlogic_gx_release_version}-mali-s905.tar.gz -O ${DOWNLOADS_DIR}/kernel-mali-amlogic_gx-armv7l.tar.gz
  rm -f ${DOWNLOADS_DIR}/boot-amlogic_gx-armv7l.dd
  wget -v https://github.com/hexdump0815/linux-mainline-and-mali-generic-stable-kernel/raw/${amlogic_gx_generic_tree_tag}/misc.av8/u-boot/boot-odroid_c2-aarch64.dd -O ${DOWNLOADS_DIR}/boot-amlogic_gx-armv7l.dd
  rm -f ${DOWNLOADS_DIR}/gl4es-armv7l-debian.tar.gz
  wget -v https://github.com/hexdump0815/linux-mainline-and-mali-generic-stable-kernel/raw/${amlogic_gx_generic_tree_tag}/misc/gl4es-armv7l-debian.tar.gz -O ${DOWNLOADS_DIR}/gl4es-armv7l-debian.tar.gz
  rm -f ${DOWNLOADS_DIR}/gl4es-armv7l-ubuntu.tar.gz
  wget -v https://github.com/hexdump0815/linux-mainline-and-mali-generic-stable-kernel/raw/${amlogic_gx_generic_tree_tag}/misc/gl4es-armv7l-ubuntu.tar.gz -O ${DOWNLOADS_DIR}/gl4es-armv7l-ubuntu.tar.gz
  rm -f ${DOWNLOADS_DIR}/xorg-armsoc-armv7l-debian.tar.gz
  wget -v https://github.com/hexdump0815/linux-mainline-and-mali-generic-stable-kernel/raw/${amlogic_gx_generic_tree_tag}/misc/xorg-armsoc-armv7l-debian.tar.gz -O ${DOWNLOADS_DIR}/xorg-armsoc-armv7l-debian.tar.gz
  rm -f ${DOWNLOADS_DIR}/xorg-armsoc-armv7l-ubuntu.tar.gz
  wget -v https://github.com/hexdump0815/linux-mainline-and-mali-generic-stable-kernel/raw/${amlogic_gx_generic_tree_tag}/misc/xorg-armsoc-armv7l-ubuntu.tar.gz -O ${DOWNLOADS_DIR}/xorg-armsoc-armv7l-ubuntu.tar.gz
  rm -f ${DOWNLOADS_DIR}/opengl-fbdev-amlogic_gx-armv7l.tar.gz
  wget -v https://github.com/hexdump0815/linux-mainline-and-mali-generic-stable-kernel/raw/${amlogic_gx_generic_tree_tag}/misc/opt-mali-s905-fbdev-armv7l.tar.gz -O ${DOWNLOADS_DIR}/opengl-fbdev-amlogic_gx-armv7l.tar.gz
  rm -f ${DOWNLOADS_DIR}/opengl-wayland-amlogic_gx-armv7l.tar.gz
  wget -v https://github.com/hexdump0815/linux-mainline-and-mali-generic-stable-kernel/raw/${amlogic_gx_generic_tree_tag}/misc/opt-mali-s905-wayland-armv7l.tar.gz -O ${DOWNLOADS_DIR}/opengl-wayland-amlogic_gx-armv7l.tar.gz
fi

if ([ "${TARGET_SYSTEM}" = "all" ] || [ "${TARGET_SYSTEM}" = "amlogic_gx" ]) && [ "${TARGET_ARCH}" = "aarch64" ]; then
  rm -f ${DOWNLOADS_DIR}/kernel-amlogic_gx_armv7l-aarch64.tar.gz
  wget -v https://github.com/hexdump0815/linux-mainline-and-mali-generic-stable-kernel/releases/download/${amlogic_gx_release_version}/${amlogic_gx_release_version}.tar.gz -O ${DOWNLOADS_DIR}/kernel-amlogic_gx-aarch64.tar.gz
  rm -f ${DOWNLOADS_DIR}/kernel-mali-amlogic_gx_armv7l-aarch64.tar.gz
  wget -v https://github.com/hexdump0815/linux-mainline-and-mali-generic-stable-kernel/releases/download/${amlogic_gx_release_version}/${amlogic_gx_release_version}-mali-s905.tar.gz -O ${DOWNLOADS_DIR}/kernel-mali-amlogic_gx-aarch64.tar.gz
  rm -f ${DOWNLOADS_DIR}/boot-amlogic_gx-aarch64.dd
  wget -v https://github.com/hexdump0815/linux-mainline-and-mali-generic-stable-kernel/raw/${amlogic_gx_generic_tree_tag}/misc.av8/u-boot/boot-odroid_c2-aarch64.dd -O ${DOWNLOADS_DIR}/boot-amlogic_gx-aarch64.dd
  rm -f ${DOWNLOADS_DIR}/gl4es-aarch64-debian.tar.gz
  wget -v https://github.com/hexdump0815/linux-mainline-and-mali-generic-stable-kernel/raw/${amlogic_gx_generic_tree_tag}/misc/gl4es-aarch64-debian.tar.gz -O ${DOWNLOADS_DIR}/gl4es-aarch64-debian.tar.gz
  rm -f ${DOWNLOADS_DIR}/gl4es-aarch64-ubuntu.tar.gz
  wget -v https://github.com/hexdump0815/linux-mainline-and-mali-generic-stable-kernel/raw/${amlogic_gx_generic_tree_tag}/misc/gl4es-aarch64-ubuntu.tar.gz -O ${DOWNLOADS_DIR}/gl4es-aarch64-ubuntu.tar.gz
  rm -f ${DOWNLOADS_DIR}/xorg-armsoc-aarch64-debian.tar.gz
  wget -v https://github.com/hexdump0815/linux-mainline-and-mali-generic-stable-kernel/raw/${amlogic_gx_generic_tree_tag}/misc/xorg-armsoc-aarch64-debian.tar.gz -O ${DOWNLOADS_DIR}/xorg-armsoc-aarch64-debian.tar.gz
  rm -f ${DOWNLOADS_DIR}/xorg-armsoc-aarch64-ubuntu.tar.gz
  wget -v https://github.com/hexdump0815/linux-mainline-and-mali-generic-stable-kernel/raw/${amlogic_gx_generic_tree_tag}/misc/xorg-armsoc-aarch64-ubuntu.tar.gz -O ${DOWNLOADS_DIR}/xorg-armsoc-aarch64-ubuntu.tar.gz
  rm -f ${DOWNLOADS_DIR}/opengl-amlogic_gx-aarch64.tar.gz
  wget -v https://github.com/hexdump0815/linux-mainline-and-mali-generic-stable-kernel/raw/${amlogic_gx_generic_tree_tag}/misc/opt-mali-s905-aarch64.tar.gz -O ${DOWNLOADS_DIR}/opengl-amlogic_gx-aarch64.tar.gz
  rm -f ${DOWNLOADS_DIR}/opengl-fbdev-amlogic_gx-aarch64.tar.gz
  wget -v https://github.com/hexdump0815/linux-mainline-and-mali-generic-stable-kernel/raw/${amlogic_gx_generic_tree_tag}/misc/opt-mali-s905-fbdev-aarch64.tar.gz -O ${DOWNLOADS_DIR}/opengl-fbdev-amlogic_gx-aarch64.tar.gz
  rm -f ${DOWNLOADS_DIR}/opengl-wayland-amlogic_gx-aarch64.tar.gz
  wget -v https://github.com/hexdump0815/linux-mainline-and-mali-generic-stable-kernel/raw/${amlogic_gx_generic_tree_tag}/misc/opt-mali-s905-wayland-aarch64.tar.gz -O ${DOWNLOADS_DIR}/opengl-wayland-amlogic_gx-aarch64.tar.gz
fi
