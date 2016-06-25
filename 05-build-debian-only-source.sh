#!/bin/bash

set -ex

. versions.sh

for i in $VERSIONS; do
  FOLDER="$(to_folder_name "$i")"
  pushd "debian-sources/$FOLDER" || exit $?
  cd "$FOLDER"
  debuild -S || exit $? # -us -uc
  popd
done
