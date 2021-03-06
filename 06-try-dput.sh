#!/bin/bash

set -ex

. versions.sh

for i in $VERSIONS; do
  FOLDER="$(to_folder_name "$i")"
  ARCHIVE="$(to_archive_name "$i")"
  pushd "debian-sources/$FOLDER" || exit $?
  PPA="$(ppa_of_version_target "$i" "$TARGET")"
  dput ppa:jgross-h/$PPA "${ARCHIVE}${PPA_EXT}_source.changes"
  #sleep 2m
  popd
done
