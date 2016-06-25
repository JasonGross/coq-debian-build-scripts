#!/bin/bash

set -ex

. versions.sh

for i in $VERSIONS; do
  FOLDER="$(to_folder_name "$i")"
  pushd "debian-sources/$FOLDER" || exit $?
  cd "$FOLDER"
  debuild -us -uc || exit $?
  popd
done
