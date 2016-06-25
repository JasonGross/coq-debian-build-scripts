#!/bin/bash

set -ex

. versions.sh

for i in $VERSIONS; do
  PKG="$(to_debian_version "$i")"
  pushd "debian-sources/coq-$PKG" || exit $?
  dput ppa:jgross-h/many-coq-versions "coq_${PKG}-1_source.changes"
  popd
done
