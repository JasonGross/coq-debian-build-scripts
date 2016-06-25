#!/bin/bash

set -ex

. versions.sh

for i in $VERSIONS; do
  PKG="$(to_debian_version "$i")"
  pushd "debian-sources/coq-$PKG" || exit 1
  cd "coq-$PKG"
  debuild -us -uc || exit 1
  popd
done
