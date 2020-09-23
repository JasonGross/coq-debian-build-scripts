#!/usr/bin/env bash

set -ex

. versions.sh

for i in ${DSCS}; do
    FOLDER="$(to_folder_name "$i")"
    pushd "debian-sources/$FOLDER" || exit $?
    debuild --prepend-path "$(dirname "$(which jbuilder)")" -S || exit $? # -us -uc
    popd
done

for i in ${DEBIAN_DSCS}; do
    FOLDER="$(to_folder_name "$i")"
    pushd "debian-sources/$FOLDER" || exit $?
    debuild --prepend-path "$(dirname "$(which jbuilder)")" -sa -S || exit $? # -us -uc
    popd
done
