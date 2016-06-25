#!/bin/bash

set -ex

. versions.sh

for i in $VERSIONS; do
  PKG="$(to_debian_version "$i")"
  pushd "debian-sources/coq-$PKG" || exit $?
  cd "coq-$PKG"
  debuild -S || exit $? # -us -uc
  popd
done
