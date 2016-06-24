#!/bin/bash

. versions.sh

for i in $VERSIONS; do
  PKG="$(to_debian_version "$i")"
  pushd "debian-sources/coq-$PKG" || exit 1
  dch --create -v "$i-1" --package coq || exit 1
  popd
done