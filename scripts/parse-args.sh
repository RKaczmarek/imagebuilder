#!/bin/bash

join() { local IFS="$1"; shift; echo "$*"; }

declare -A ARGUMENTS
declare -a UNKNOWN

for i in "$@"
do
case $i in
    -a=*|--arch=*|--architecture=*)
        ARGUMENTS[ARCHITECTURE]="${i#*=}"
        shift
    ;;
    -d=*|--dist=*|--distribution=*)
        ARGUMENTS[DIST]="${i#*=}"
        shift
    ;;
    -c=*|--cache=*|--cache-dir=*)
        ARGUMENTS[DIR_CACHE]="${i#*=}"
        shift
    ;;
    -h|--help)
        ARGUMENTS[HELP]=1
        shift
    ;;
    -o=*|--out=*|--out-dir=*)
        ARGUMENTS[DIR_OUT]="${i#*=}"
        shift
    ;;
    -s=*|--system=*)
        ARGUMENTS[SYSTEM]="${i#*=}"
        shift
    ;;
    --force-bootstrap)
        ARGUMENTS[FORCE_BOOTSTRAP]=1
        shift
    ;;
    *)
        # unknown option
        UNKNOWN+=( "$i" )
    ;;
esac
done

ARG_LIST=""

for K in "${!ARGUMENTS[@]}";
do
    ARG_LIST+="$K;${ARGUMENTS[$K]} "
done

if [ ${#UNKNOWN[@]} -gt 0 ]
then
    ARG_LIST+="UNKNOWN;$( join , ${UNKNOWN[@]} )"
fi

echo $ARG_LIST
