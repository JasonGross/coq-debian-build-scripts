#!/usr/bin/env bash

set -ex

. versions.sh

for i in ${DSCS} ${DEBIAN_DSCS}; do
    FOLDER="$(to_folder_name "$i")"
    pushd "debian-sources/$FOLDER" || exit $?
    EXTRA_ARGS="$(extra_debuild_args_for "$i")"
    debuild --prepend-path "$(dirname "$(which jbuilder)")" -d ${EXTRA_ARGS} -S || exit $? # -us -uc
    popd
done
