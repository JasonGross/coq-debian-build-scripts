#!/bin/bash

set -ex

. versions.sh

for i in $VERSIONS; do
  FOLDER="$(to_folder_name "$i")"
  ARCHIVE="$(to_archive_name "$i")"
  pushd "debian-sources/$FOLDER" || exit $?
  OCAML3_PPA="many-coq-versions-ocaml-3"
  OCAML4_05_PPA="many-coq-versions-ocaml-4-05"
  if vercmp "$i" "<" "8.5~"; then
    dput ppa:jgross-h/$OCAML3_PPA "${ARCHIVE}${PPA_EXT}_source.changes"
  elif vercmp "$i" "<" "8.10~"; then
    dput ppa:jgross-h/many-coq-versions "${ARCHIVE}${PPA_EXT}_source.changes"
  else
    dput ppa:jgross-h/$OCAML4_05_PPA "${ARCHIVE}${PPA_EXT}_source.changes"
  fi
  #sleep 2m
  popd
done
