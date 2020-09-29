#!/bin/bash
set -e

### --- define paths and path defaults --- ###

PATH_RUN=$( pwd )
PATH_RUN_RELATIVE=$0
cd $( dirname $0 )
PATH_PROJECT_ROOT=$( pwd )
PATH_LIB=$PATH_PROJECT_ROOT/lib

### --- import functions --- ###

. $PATH_LIB/common.lib
. $PATH_LIB/options.lib
. $PATH_LIB/paths.lib
. $PATH_LIB/files.lib
. $PATH_LIB/distribution.lib
. $PATH_LIB/image.lib

### --- run application --- ###

load_options $@
validate_options

if [[ $( contains_option HELP ) == 1 ]]
then
    print_help
    exit 0
fi

load_paths $PATH_PROJECT_ROOT
download_files
recreate_build_path
bootstrap
create_fs || create_fs_cleanup
create_image

if [ "${?}" -ne 0 ]
then
    exit "${?}"
fi
