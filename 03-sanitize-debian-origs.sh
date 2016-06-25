#!/bin/bash

set -ex

. versions.sh

for i in $VERSIONS; do
  PKG="$(to_debian_version "$i")"
  rm -rf "debian-sources/coq-$PKG/coq-$PKG"
  mkdir -p "debian-sources/coq-$PKG/coq-$PKG"
  pushd "debian-sources/coq-$PKG" || exit $?
  PREORIG="coq_$PKG.preorig.tar.gz"
  ORIG="coq_$PKG.orig.tar.gz"
  cp -af "$PREORIG" "coq-$PKG/" || exit $?
  cd "coq-$PKG" || exit $?
  tar -xf "$PREORIG" || exit $?
  rm -f "$PREORIG"
  COUNT="$(ls | wc -l)"
  if [ -d "coq-$PKG" ]; then
    cd ..
    cp -af "$PREORIG" "$ORIG" || exit $?
    mv "coq-$PKG" "coq-$PKG-1" || exit $?
    mv "coq-$PKG-1/coq-$PKG" "coq-$PKG" || exit $?
    rm -rf "coq-$PKG-1" || exit $?
  elif [ "$COUNT" -eq 1 ]; then
    mv "$(ls)" "coq-$PKG" || exit $?
    tar -czf "../$ORIG" "coq-$PKG" || exit $?
    cd ..
    mv "coq-$PKG" "coq-$PKG-1" || exit $?
    mv "coq-$PKG-1/coq-$PKG" "coq-$PKG" || exit $?
    rm -rf "coq-$PKG-1" || exit $?
  else
    ls
    exit 1
  fi
  popd
done
