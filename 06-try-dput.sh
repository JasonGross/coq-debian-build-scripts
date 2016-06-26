#!/bin/bash

set -ex

. versions.sh

for i in $VERSIONS; do
  FOLDER="$(to_folder_name "$i")"
  ARCHIVE="$(to_archive_name "$i")"
  pushd "debian-sources/$FOLDER" || exit $?
  if [ "$TARGET" == trusty ]; then
    dput ppa:jgross-h/many-coq-versions "${ARCHIVE}${PPA_EXT}_source.changes"
  elif [ "$TARGET" == precise ]; then
    dput ppa:jgross-h/many-coq-versions-ocaml-3 "${ARCHIVE}${PPA_EXT}_source.changes"
  fi
  #sleep 2m
  popd
done
