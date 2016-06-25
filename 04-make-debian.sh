#!/bin/bash

set -ex

. versions.sh

SPACE=" "

for i in $VERSIONS; do
  VERSION="$(to_debian_version "$i")"
  PKG="$(to_package_name "$i")"
  FOLDER="$(to_folder_name "$i")"
  ARCHIVE="$(to_archive_name "$i")"
  pushd "debian-sources/$FOLDER" || exit $?
  cd "$FOLDER"
  rm -rf debian
  mkdir -p debian || exit $?
  if [ -z "$DEBFULLNAME" ]; then export DEBFULLNAME="Jason Gross"; fi
  if [ -z "$DEBEMAIL" ]; then export DEBEMAIL="jgross@mit.edu"; fi
  EDITOR="true" dch --create -v "${VERSION}-1" --package "$PKG" || exit $?
  sed -i s'/ (Closes: #XXXXXX)//g' debian/changelog || exit $?
  echo '9' > debian/compat # magic number from https://wiki.debian.org/Packaging/Intro?action=show&redirect=IntroDebianPackaging
  cat > debian/control <<EOF
Source: coq
Maintainer: $DEBFULLNAME <$DEBEMAIL>
Section: misc
Priority: optional
Standards-Version: 3.9.5
Build-Depends: debhelper (>= 9), dh-ocaml (>= 0.9.5~), ocaml-nox (>= 4), ocaml-best-compilers, ocaml-findlib (>= 1.4), camlp5 (>= 5.12-2~), liblablgtk2-ocaml-dev (>= 2.14), liblablgtksourceview2-ocaml-dev, texlive-latex-extra, hevea (>= 1.10-7)


Package: coq
Architecture: any
Depends: \${shlibs:Depends}, \${misc:Depends}
Homepage: http://coq.inria.fr/
Description: Coq is a proof assistant for higher-order logic, which allows the development of computer programs consistent with their formal specification. It is developed using Objective Caml and Camlp5.
EOF
  # cribbed from http://http.debian.net/debian/pool/main/c/coq/coq_8.5-2.debian.tar.xz
  cat ../../debian-rules.in | sed s"/@@@COQ_VERSION@@@/$i/g" > debian/rules
  mkdir -p debian/source
  echo '3.0 (quilt)' > debian/source/format || exit $? # magic from https://wiki.debian.org/Packaging/Intro?action=show&redirect=IntroDebianPackaging
  if [ -e COPYRIGHT ]; then
    COPYRIGHT="$(cat COPYRIGHT | tr '\n' '~' | sed s'/ ~/~/g' | sed s'/~/ /g' | grep -o 'Copyright [^\.]*')"
  else
    COPYRIGHT="1999-2015 The Coq development team, INRIA, CNRS, University Paris Sud, University Paris 7, Ecole Polytechnique"
  fi
  cat > debian/copyright <<EOF
Format: http://www.debian.org/doc/packaging-manuals/copyright-format/1.0/
Packaged-By: Fernando Sanchez <fer@debian.org>
Packaged-Date: Fri, 03 Dec 1999 22:06:04 +0100
Source: http://coq.inria.fr/

Files: *
Copyright: ${COPYRIGHT}
License: LGPL-2.1

Files: debian/*
Copyright: 1999-2000 Fernando Sanchez <fer@debian.org>
           2001-2002 Judicael Courant <Judicael.Courant@lri.fr>
           2004-2009 Samuel Mimram <smimram@debian.org>
           2008-2014 Stéphane Glondu <glondu@debian.org>
           2016-2016 Jason Gross <jgross@mit.edu>
License: LGPL-2.1

License: LGPL-2.1
 The Coq Proof Assistant is distributed under the terms of the GNU
 Lesser General Public Licence, version 2.1, see
 \`/usr/share/common-licenses/LGPL-2.1'.
EOF
  popd
done
