#!/bin/bash

set -ex

. versions.sh

for i in $VERSIONS; do
  PKG="$(to_debian_version "$i")"
  pushd "debian-sources/coq-$PKG" || exit $?
  cd "coq-$PKG"
  debuild -us -uc -S || exit $?
  popd
done
