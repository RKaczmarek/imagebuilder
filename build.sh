#!/bin/bash
set -e

### --- declare functions --- ###

error() {
    echo "Error: $@" 1>&2
}

fail() {
    error "$@"
    exit 1
}

validate_system() {
    local SYSTEM=$1
    local VALID=1
    case "$SYSTEM" in
        chromebook_snow) ;;
        chromebook_veyron) ;;
        chromebook_nyanbig) ;;
        odroid_u3) ;;
        orbsmart_s92_beelink_r89) ;;
        tinkerboard) ;;
        raspberry_pi) ;;
        raspberry_pi_4) ;;
        amlogic_gx) ;;
        *) VALID=0 ;;
    esac
    echo $VALID    
}

validate_arch() {
    local ARCH=$1
    local VALID=1
    case "$ARCH" in
        armv7l) ;;
        aarch64) ;;
        *) VALID=0 ;;
    esac
    echo $VALID    
}

validate_dist() {
    local DIST=$1
    local VALID=1
    case "$DIST" in
        ubuntu) ;;
        debian) ;;
        *) VALID=0 ;;
    esac
    echo $VALID    
}

### --- end of declare functions --- ###

### --- define paths and path defaults --- ###

DIR_RUN=$( pwd )
cd $( dirname $0 )
DIR_PROJECT_ROOT=$( pwd )
DIR_SCRIPTS=$DIR_PROJECT_ROOT/scripts
DIR_CACHE=$DIR_PROJECT_ROOT/cache
DIR_OUT=$DIR_PROJECT_ROOT/out

### --- end of define paths --- ###

declare -A ARGUMENTS

PARSED_ARGS=( $( ${DIR_SCRIPTS}/parse-args.sh $@ ) )
for PARSED_ARG in "${PARSED_ARGS[@]}"
do
    ARG_PAIR=( ${PARSED_ARG//;/ } )
    ARGUMENTS[${ARG_PAIR[0]}]=${ARG_PAIR[1]}
done

if [ ${ARGUMENTS[HELP]+_} ]
then
    $DIR_SCRIPTS/print-help.sh
    exit 0
fi

if [ ${ARGUMENTS[UNKNOWN]+_} ]
then
    fail "Unknown argument(s) ${ARGUMENTS[UNKNOWN]}"
fi

if [ $( validate_system ${ARGUMENTS[SYSTEM]} ) -eq 0 ]
then
    fail "System ${ARGUMENTS[SYSTEM]} ist not valid. Run with argument -h to print more information"
fi

if [ $( validate_arch ${ARGUMENTS[ARCHITECTURE]} ) -eq 0 ]
then
    fail "Architecture ${ARGUMENTS[ARCHITECTURE]} ist not valid. Run with argument -h to print more information"
fi

if [ $( validate_dist ${ARGUMENTS[DIST]} ) -eq 0 ]
then
    fail "Distribution ${ARGUMENTS[DIST]} ist not valid. Run with argument -h to print more information"
fi

if [ ${ARGUMENTS[DIR_CACHE]+_} ]
then
    if [ ! -d ${ARGUMENTS[DIR_OUT]} ]
    then
        fail echo "The output directory ${ARGUMENTS[DIR_OUT]} does not exist"
    fi
    
    DIR_CACHE=${ARGUMENTS[DIR_CACHE]}
else
    if [ ! -d $DIR_CACHE ]
    then
        mkdir $DIR_CACHE
    fi
fi

if [ ${ARGUMENTS[DIR_OUT]+_} ]
then
    if [ ! -d "${ARGUMENTS[DIR_OUT]}" ]
    then
        fail echo "The output directory ${ARGUMENTS[DIR_OUT]} does not exist"
    fi

    DIR_OUT=${ARGUMENTS[DIR_OUT]}
fi

DIR_BUILD=$DIR_OUT/build
DIR_DIST=$DIR_OUT/dist

if [ -d "$DIR_BUILD" ]
then
    echo "Deleting build directory $DIR_BUILD"
    rm -R "$DIR_BUILD"
fi

echo "Creating build directory $DIR_BUILD"
mkdir -p "$DIR_BUILD"

echo "$DIR_SCRIPTS/bootstrap.sh $DIR_CACHE $DIR_BUILD ${ARGUMENTS[ARCHITECTURE]} ${ARGUMENTS[DIST]} ${ARGUMENTS[FORCE_BOOTSTRAP]}"
$DIR_SCRIPTS/bootstrap.sh $DIR_CACHE $DIR_BUILD ${ARGUMENTS[ARCHITECTURE]} ${ARGUMENTS[DIST]} ${ARGUMENTS[FORCE_BOOTSTRAP]}
