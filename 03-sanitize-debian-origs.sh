#!/bin/bash

set -ex

. versions.sh

for i in $VERSIONS; do
  FOLDER="$(to_folder_name "$i")"
  ARCHIVE="$(to_archive_name "$i")"
  rm -rf "debian-sources/$FOLDER/$FOLDER"
  mkdir -p "debian-sources/$FOLDER/$FOLDER"
  pushd "debian-sources/$FOLDER" || exit $?
  PREORIG="$ARCHIVE.preorig.tar.gz"
  ORIG="$ARCHIVE.orig.tar.gz"
  cp -af "$PREORIG" "$FOLDER/" || exit $?
  cd "$FOLDER" || exit $?
  tar -xf "$PREORIG" || exit $?
  rm -f "$PREORIG"
  COUNT="$(ls | wc -l)"
  if [ -d "$FOLDER" ]; then
    cd ..
    cp -af "$PREORIG" "$ORIG" || exit $?
    mv "$FOLDER" "$FOLDER-1" || exit $?
    mv "$FOLDER-1/$FOLDER" "$FOLDER" || exit $?
    rm -rf "$FOLDER-1" || exit $?
  elif [ "$COUNT" -eq 1 ]; then
    mv "$(ls)" "$FOLDER" || exit $?
    tar -czf "../$ORIG" "$FOLDER" || exit $?
    cd ..
    mv "$FOLDER" "$FOLDER-1" || exit $?
    mv "$FOLDER-1/$FOLDER" "$FOLDER" || exit $?
    rm -rf "$FOLDER-1" || exit $?
  else
    ls
    exit 1
  fi
  popd
done
