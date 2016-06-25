#!/bin/bash

set -ex

. versions.sh

for i in $VERSIONS; do
  FOLDER="$(to_folder_name "$i")"
  ARCHIVE="$(to_archive_name "$i")"
  mkdir -p "debian-sources/$FOLDER"
  cp -af "coq-source/coq-$i.tar.gz" "debian-sources/$FOLDER/$ARCHIVE.preorig.tar.gz" || exit $?
done
