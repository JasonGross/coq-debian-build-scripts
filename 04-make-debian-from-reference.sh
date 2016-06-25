#!/bin/bash

set -ex

. versions.sh

SPACE=" "

for i in $VERSIONS; do
  PKG="$(to_debian_version "$i")"
  pushd "debian-sources/coq-$PKG" || exit $?
  cd "coq-$PKG"
  rm -rf debian
  mkdir -p debian || exit $?
  if [ -z "$DEBFULLNAME" ]; then export DEBFULLNAME="Jason Gross"; fi
  if [ -z "$DEBEMAIL" ]; then export DEBEMAIL="jgross@mit.edu"; fi
  EDITOR="true" dch --create -v "$i-1" --package coq || exit $?
  sed -i s'/ (Closes: #XXXXXX)//g' debian/changelog || exit $?
  mv debian debian-orig
  cp -a ../../../reference-from-coq_8.5-2/debian ./ || exit $?
  mv -f debian-orig/* debian/ || exit $?
  rm -r debian-orig || exit $?
  popd
done
