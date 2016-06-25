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
  EDITOR="true" dch --create -v "$PKG$PPA_EXT" --package coq || exit $?
  sed -i s'/ (Closes: #XXXXXX)//g' debian/changelog || exit $?
  if [[ "$PKG" == *"~"* ]]; then
    sed -i s'/UNRELEASED/trusty/g' debian/changelog || exit $?
  else
    sed -i s'/UNRELEASED/trusty/g' debian/changelog || exit $?
  fi
  mv debian debian-orig
  cp -a ../../../reference-from-coq_8.5-2/debian ./ || exit $?
  mv -f debian-orig/* debian/ || exit $?
  rm -r debian-orig || exit $?
  sed s"/COQ_VERSION := .*/COQ_VERSION := $i/g" -i debian/rules || exit $?
  if [ ! -e 'test-suite/bugs/closed/4429.v' ]; then rm -f debian/patches/0003-Remove-test-4429.patch; fi
  if [ ! -e 'test-suite/bugs/closed/4366.v' ]; then rm -f debian/patches/0002-Remove-test-4366-too-picky-on-the-timeout.patch; fi
  (cd debian/patches && ls *.patch | sort) > debian/patches/series
  popd
done
