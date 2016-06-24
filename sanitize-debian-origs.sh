#!/bin/bash

set -ex

. versions.sh

for i in $VERSIONS; do
  PKG="$(to_debian_version "$i")"
  rm -rf "debian-sources/coq-$PKG/coq-$PKG"
  mkdir -p "debian-sources/coq-$PKG/coq-$PKG"
  pushd "debian-sources/coq-$PKG" || exit 1
  PREORIG="coq_$PKG.preorig.tar.gz"
  ORIG="coq_$PKG.orig.tar.gz"
  cp -af "$PREORIG" "coq-$PKG/" || exit 1
  cd "coq-$PKG" || exit 1
  tar -xf "$PREORIG" || exit 1
  rm -f "$PREORIG"
  COUNT="$(ls | wc -l)"
  if [ -d "coq-$PKG" ]; then
    cd ..
    cp -af "$PREORIG" "$ORIG" || exit 1
    mv "coq-$PKG" "coq-$PKG-1" || exit 1
    mv "coq-$PKG-1/coq-$PKG" "coq-$PKG" || exit 1
    rm -rf "coq-$PKG-1" || exit 1
  elif [ "$COUNT" -eq 1 ]; then
    mv "$(ls)" "coq-$PKG" || exit 1
    tar -cf "../$ORIG" "coq-$PKG" || exit 1
    cd ..
    mv "coq-$PKG" "coq-$PKG-1" || exit 1
    mv "coq-$PKG-1/coq-$PKG" "coq-$PKG" || exit 1
    rm -rf "coq-$PKG-1" || exit 1
  else
    ls
    exit 1
  fi
  popd
done
