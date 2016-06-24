#!/bin/bash

set -ex

. versions.sh

for i in $VERSIONS; do
  PKG="$(to_debian_version "$i")"
  mkdir -p debian-sources/coq-$PKG
  cp -af coq-source/coq-$i.tar.gz debian-sources/coq-$PKG/coq_$PKG.preorig.tar.gz || exit 1
done
