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
  cat > debian/rules <<'EOF'
#!/usr/bin/make -f
%:
	dh "$@"
EOF
  mkdir -p debian/source
  echo '3.0 (quilt)' > debian/source/format || exit $? # magic from https://wiki.debian.org/Packaging/Intro?action=show&redirect=IntroDebianPackaging
  cp -f LICENSE debian/copyright || touch debian/copyright
  popd
done
