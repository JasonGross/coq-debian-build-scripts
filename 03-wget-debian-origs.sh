#!/usr/bin/env bash

set -ex

. versions.sh

for i in $VERSIONS; do
  FOLDER="$(to_folder_name "$i")"
  ARCHIVE="$(to_archive_name "$i")"
  pushd "debian-sources/$FOLDER" || exit $?
  PPA="$(ppa_of_version_target "$i" "$TARGET")"
  wget "https://launchpad.net/~jgross-h/+archive/ubuntu/$PPA/+sourcefiles/$(to_package_name "$i")/$(to_debian_version "$i")$(ppa_wget_ext_of_version "$i")/${ARCHIVE}.orig.tar.gz" -O "${ARCHIVE}.orig.tar.gz"
  #sleep 2m
  popd
done
