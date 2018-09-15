#!/usr/bin/env bash

set -ex

. versions.sh

for i in $DSCS; do
    FOLDER="$(to_folder_name "$i")"
    pushd "debian-sources/$FOLDER" || exit $?
    debuild -S || exit $? # -us -uc
    popd
done
