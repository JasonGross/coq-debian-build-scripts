#!/bin/bash

set -ex

. versions.sh

for i in $DSCS; do
    FOLDER="$(to_folder_name "$i")"
    PREVERSION="$(to_preversion "$i")"
    VERSION="$(to_version "$i")"
    pushd "debian-sources"
    dpkg-source -x "$i" || exit $?
    cd "${FOLDER}"
    sed 's/debhelper ([^)]*)/debhelper (>= 9)/g' -i debian/control
    sed 's/ocaml-native-compilers .= $${binary:Version}./ocaml-native-compilers/g' -i debian/rules
    sed 's/ocaml-best-compilers .= ${binary:Version}./ocaml-best-compilers/g' -i debian/control
    if [ -f debian/control.in ]; then
        sed 's/ocaml-best-compilers .= ${binary:Version}./ocaml-best-compilers/g' -i debian/control.in
    fi
    echo '9' > debian/compat # magic number from https://wiki.debian.org/Packaging/Intro?action=show&redirect=IntroDebianPackaging
    if [ -z "$DEBFULLNAME" ]; then export DEBFULLNAME="Jason Gross"; fi
    if [ -z "$DEBEMAIL" ]; then export DEBEMAIL="jgross@mit.edu"; fi
    PREFIX="$(grep -m 1 -o '^[a-z0-9]\+ ([^)]\+' debian/changelog | sed s'/^[a-z0-9]\+ (//g' | sed s"/${PREVERSION}.*\$//g")"
    dch -v "${PREFIX}${VERSION}" "Relax debhelper version dependency" || exit $?
    sed -i s'/UNRELEASED/'"$TARGET"'/g' debian/changelog || exit $?
    popd
done
