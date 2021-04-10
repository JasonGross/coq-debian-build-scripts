#!/bin/bash

set -ex

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

. versions.sh

for i in ${DSCS} ${DEBIAN_DSCS}; do
    FOLDER="$(to_folder_name "$i")"
    PREVERSION="$(to_preversion "$i")"
    VERSION="$(to_version "$i")"
    pushd "debian-sources"
    rm -rf "${FOLDER}"
    dpkg-source -x "$i" || exit $?
    cd "${FOLDER}"
    sed 's/debhelper ([^)]*)/debhelper (>= 9)/g' -i debian/control
    sed 's/debhelper-compat ([^)]*)/debhelper (>= 9)/g' -i debian/control
    sed 's/dpkg-dev ([^)]*)/dpkg-dev/g' -i debian/control
    if [[ "$i" == "${OCAML_BASE}.dsc" ]]; then
        sed 's/\(binutils-dev\)[^,]*,/\1 (>= 2.23),/g' -i debian/control
        patch -p1 -R < debian/patches/0006-Disable-DT_TEXTREL-warnings-on-Linux-i386.patch
        cp -f "${DIR}/fixes/0006-Disable-DT_TEXTREL-warnings-on-Linux-i386.patch" debian/patches/
        patch -p1 < debian/patches/0006-Disable-DT_TEXTREL-warnings-on-Linux-i386.patch
    fi
    if [[ "$i" == "${FINDLIB_BASE}.dsc" ]]; then
        sed 's/ocaml-nox (>= 4.03.0),/ocaml-nox (>= 4.03.0), ocaml-nox (<< 4.09~) | libgraphics-ocaml-dev,/g' -i debian/control
    fi
    if [[ "$i" == "${OCAML_ZARITH_BASE}.dsc" ]]; then
        sed 's/libgmp3-dev,/libgmp3-dev (>= 2:5.1),/g' -i debian/control
    fi
    sed 's/ocaml-native-compilers .= $${binary:Version}./ocaml-native-compilers/g' -i debian/rules
    sed 's/ocaml-best-compilers .= ${binary:Version}./ocaml-best-compilers/g' -i debian/control
    if [ "$TARGET" == "xenial" ] || [ "$TARGET" == "trusty" ] || [ "$TARGET" == "precise" ]; then
        sed 's/ --doc-main-package=[^ ]*//g' -i debian/rules
    fi
    if [ -f debian/control.in ]; then
        sed 's/ocaml-best-compilers .= ${binary:Version}./ocaml-best-compilers/g' -i debian/control.in
    fi
    echo '9' > debian/compat # magic number from https://wiki.debian.org/Packaging/Intro?action=show&redirect=IntroDebianPackaging
    if [ -z "$DEBFULLNAME" ]; then export DEBFULLNAME="Jason Gross"; fi
    if [ -z "$DEBEMAIL" ]; then export DEBEMAIL="jgross@mit.edu"; fi
    PREFIX="$(grep -m 1 -o '^[a-z0-9-]\+ ([^)]\+' debian/changelog | sed s'/^[a-z0-9-]\+ (//g' | sed s"/${PREVERSION}.*\$//g")"
    dch -v "${PREFIX}${VERSION}" "Relax debhelper version dependency" || exit $?
    sed -i s'/UNRELEASED/'"$TARGET"'/g' debian/changelog || exit $?
    popd
done
