#!/bin/bash

set -ex

. versions.sh

for i in $VERSIONS; do
  PKG="$(to_debian_version "$i")"
  pushd "debian-sources/coq-$PKG" || exit 1
  cd "coq-$PKG"
  rm -rf debian
  mkdir -p debian || exit 1
  # Set DEBFULLNAME, DEBEMAIL
  EDITOR="true" dch --create -v "$i-1" --package coq || exit 1
  sed -i s'/ (Closes: #XXXXXX)//g' debian/changelog || exit 1
  echo '9' > debian/compat # magic number from https://wiki.debian.org/Packaging/Intro?action=show&redirect=IntroDebianPackaging
  cat > debian/control <<EOF
Source: coq
Maintainer: $DEBFULLNAME <$DEBEMAIL>
Section: misc
Priority: optional
Standards-Version: 3.9.5
Build-Depends: debhelper (>= 9), dh-ocaml (>= 0.9.5~), ocaml-nox (>= 4), ocaml-best-compilers, ocaml-findlib (>= 1.4), camlp5 (>= 5.12-2~), liblablgtk2-ocaml-dev (>= 2.14), liblablgtksourceview2-ocaml-dev, texlive-latex-extra, hevea (>= 1.10-7)


Package: coq
Binary: coq, coqide, coq-theories, libcoq-ocaml, libcoq-ocaml-dev
Architecture: any
Depends: \${shlibs:Depends}, \${misc:Depends}
Package-List:
 coq deb math optional arch=any
 coq-theories deb math optional arch=any
 coqide deb math optional arch=any
 libcoq-ocaml deb ocaml optional arch=any
 libcoq-ocaml-dev deb ocaml optional arch=any
Homepage: http://coq.inria.fr/
Description: Coq is a proof assistant for higher-order logic, which allows the development of computer programs consistent with their formal specification. It is developed using Objective Caml and Camlp5.

  This package provides coqtop, a command line interface to Coq.

  A graphical interface for Coq is provided in the coqide package. Coq can also be used with ProofGeneral, which allows proofs to be edited using emacs and xemacs. This requires the proofgeneral package to be installed.
EOF
  cat > debian/rules <<_EOF
#!/usr/bin/make -f
%:
	dh $@
_EOF
  mkdir -p debian/source
  echo '3.0 (quilt)' > debian/source/format || exit 1 # magic from https://wiki.debian.org/Packaging/Intro?action=show&redirect=IntroDebianPackaging
  cp -f LICENSE debian/copyright || touch debian/copyright
  popd
done
