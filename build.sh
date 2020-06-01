#!/bin/bash
set -e

### --- define paths and path defaults --- ###

PATH_RUN=$( pwd )
PATH_RUN_RELATIVE=$0
cd $( dirname $0 )
PATH_PROJECT_ROOT=$( pwd )
PATH_SCRIPTS=$PATH_PROJECT_ROOT/scripts

### --- import functions --- ###

. $PATH_SCRIPTS/common.bib
. $PATH_SCRIPTS/options.bib
. $PATH_SCRIPTS/paths.bib
. $PATH_SCRIPTS/bootstrap.bib

### --- run application --- ###

load_options $@
validate_options

if [[ "$( contains_option HELP )" == 1 ]]
then
    print_help
    exit 0
fi

load_paths $PATH_PROJECT_ROOT
recreate_build_path
bootstrap

if [ "${?}" -ne 0 ]
then
    exit "${?}"
fi
