#!/bin/bash

set -ex

. versions.sh

for i in $VERSIONS; do
  FOLDER="$(to_folder_name "$i")"
  ARCHIVE="$(to_archive_name "$i")"
  pushd "debian-sources/$FOLDER" || exit $?
  OCAML3_PPA="many-coq-versions-ocaml-3-temp-while-over-quota"
  if [ "$TARGET" == trusty ]; then
    if [[ "$i" == 8.4* ]]; then
      dput ppa:jgross-h/$OCAML3_PPA "${ARCHIVE}${PPA_EXT}_source.changes"
    fi
    dput ppa:jgross-h/many-coq-versions "${ARCHIVE}${PPA_EXT}_source.changes"
  elif [ "$TARGET" == precise ]; then
    if [[ "$i" == 8.* ]] && [[ "$i" != 8.4* ]] && [[ "$i" != 8.3* ]] && [[ "$i" != 8.2* ]] && [[ "$i" != 8.1* ]] && [[ "$i" != 8.0* ]]; then
      dput ppa:jgross-h/many-coq-versions "${ARCHIVE}${PPA_EXT}_source.changes"
    else
      dput ppa:jgross-h/$OCAML3_PPA "${ARCHIVE}${PPA_EXT}_source.changes"
    fi
  else
    dput ppa:jgross-h/many-coq-versions "${ARCHIVE}${PPA_EXT}_source.changes"
  fi
  #sleep 2m
  popd
done
