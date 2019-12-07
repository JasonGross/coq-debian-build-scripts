#!/bin/bash

set -ex

. versions.sh

for i in $VERSIONS; do
  FOLDER="$(to_folder_name "$i")"
  ARCHIVE="$(to_archive_name "$i")"
  pushd "debian-sources/$FOLDER" || exit $?
  OCAML3_PPA="many-coq-versions-ocaml-3-temp-while-over-quota"
  OCAML4_05_PPA="many-coq-versions-ocaml-4-05"
  if [ "$TARGET" == trusty ]; then
    if [[ "$i" == 8.4* ]]; then
      dput ppa:jgross-h/$OCAML3_PPA "${ARCHIVE}${PPA_EXT}_source.changes"
    elif vercmp "$i" ">=" "8.5~" && vercmp "$i" "<" "8.10~"; then
      dput ppa:jgross-h/many-coq-versions "${ARCHIVE}${PPA_EXT}_source.changes"
    else
      dput ppa:jgross-h/$OCAML4_05_PPA "${ARCHIVE}${PPA_EXT}_source.changes"
    fi
  elif [ "$TARGET" == precise ]; then
      if vercmp "$i" ">=" "8.5~"; then
        if vercmp "$i" "<" "8.10~"; then
          dput ppa:jgross-h/many-coq-versions "${ARCHIVE}${PPA_EXT}_source.changes"
        else
          dput ppa:jgross-h/$OCAML4_05_PPA "${ARCHIVE}${PPA_EXT}_source.changes"
        fi
    else
      dput ppa:jgross-h/$OCAML3_PPA "${ARCHIVE}${PPA_EXT}_source.changes"
    fi
  else
    if vercmp "$i" ">=" "8.5~" && vercmp "$i" "<" "8.10~"; then
      dput ppa:jgross-h/many-coq-versions "${ARCHIVE}${PPA_EXT}_source.changes"
    else
      dput ppa:jgross-h/$OCAML4_05_PPA "${ARCHIVE}${PPA_EXT}_source.changes"
    fi
  fi
  #sleep 2m
  popd
done
