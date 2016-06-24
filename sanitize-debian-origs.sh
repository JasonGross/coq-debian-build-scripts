#!/bin/bash

set -ex

. versions.sh

for i in $VERSIONS; do
  PKG="$(to_debian_version "$i")"
  rm -rf debian-sources/coq-$PKG/coq-$PKG
  mkdir -p debian-sources/coq-$PKG/coq-$PKG
  pushd debian-sources/coq-$PKG
  cp -af coq_$PKG.preorig.tar.gz coq-$PKG/
  cd coq-$PKG
  tar -xf coq_$PKG.preorig.tar.gz || exit 1
  rm -f coq_$PKG.preorig.tar.gz
  popd
done
