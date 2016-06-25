#!/bin/bash

set -ex

. versions.sh

for i in $VERSIONS; do
  PKG="$(to_debian_version "$i")"
  pushd "debian-sources/coq-$PKG" || exit $?
  dput ppa:jgross-h/many-coq-versions "coq_${PKG}${PPA_EXT}_source.changes"
  popd
done
