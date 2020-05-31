#!/bin/bash

declare -A ARCH_MAP=( [armv7l]=armhf [aarch64]=arm64 )

DIR_CACHE_ROOT=$1
DIR_TARGET=$2
BOOTSTRAP_ARCH=$3
BOOTSTRAP_DIST=$4
REBUILD=$5

if [ ! ${ARCH_MAP[$BOOTSTRAP_ARCH]+_} ]
then
    echo "Invalid architecture $BOOTSTRAP_ARCH for bootstrapping $BOOTSTRAP_DIST"
    exit 1
fi

BOOTSTRAP_ARCH=${ARCH_MAP[$BOOTSTRAP_ARCH]}
DIR_BOOTSTRAP=$DIR_CACHE_ROOT/bootstrap/$BOOTSTRAP_DIST/$BOOTSTRAP_ARCH

if [ ! -d "$DIR_CACHE_ROOT" ]
then
    echo "The cache directory $DIR_CACHE_ROOT for bootstrapping does not exist."
    exit 1
fi

if [ ! -d "$DIR_TARGET" ]
then
    echo "The target directory $DIR_TARGET for bootstrapping does not exist."
    exit 1
fi

if [ -n "$REBUILD" ]
then
    echo "Recreating bootstrap for $BOOTSTRAP_DIST ($BOOTSTRAP_ARCH)"

    if [ -d $DIR_BOOTSTRAP ]
    then
        rm -r $DIR_BOOTSTRAP
    fi
fi

if [ ! -d "$DIR_BOOTSTRAP" ]
then
    echo "Caching bootstrap for $BOOTSTRAP_DIST ($BOOTSTRAP_ARCH) in $DIR_BOOTSTRAP"
    mkdir -p "$DIR_BOOTSTRAP"

    case "$BOOTSTRAP_DIST" in
        ubuntu)
            LANG=C debootstrap --arch=$BOOTSTRAP_ARCH focal $DIR_BOOTSTRAP http://ports.ubuntu.com/
        ;;
        debian)
            LANG=C debootstrap --variant=minbase --arch=$BOOTSTRAP_ARCH buster $DIR_BOOTSTRAP http://deb.debian.org/debian/
        ;;
    esac
fi

rsync -aHAX --info=progress2 $DIR_BOOTSTRAP/ $DIR_TARGET
