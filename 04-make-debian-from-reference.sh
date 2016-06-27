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
  EDITOR="true" dch --create -v "$VERSION$PPA_EXT" --package "$PKG" || exit $?
  sed -i s'/ (Closes: #XXXXXX)//g' debian/changelog || exit $?
  if [[ "$VERSION" == *"~"* ]]; then
    sed -i s'/UNRELEASED/'"$TARGET"'/g' debian/changelog || exit $?
  else
    sed -i s'/UNRELEASED/'"$TARGET"'/g' debian/changelog || exit $?
  fi
  mv debian debian-orig
  if [[ "$i" == 8.4* ]]; then
    cp -a ../../../reference-from-coq_8.4pl3/debian ./ || exit $?
  elif [[ "$i" == 8.3* ]]; then
    cp -a ../../../reference-from-coq_8.3p4/debian ./ || exit $?
  elif [[ "$i" == 8.2* ]]; then
    cp -a ../../../reference-from-coq_8.2pl2/debian ./ || exit $?
  elif [[ "$i" == 8.1* ]]; then
    cp -a ../../../reference-from-coq_8.1pl3/debian ./ || exit $?
  elif [[ "$i" == 8.0* ]]; then
    cp -a ../../../reference-from-coq_8.0pl3/debian ./ || exit $?
  elif [[ "$i" == 7.3* ]]; then
    cp -a ../../../reference-from-coq_7.3.1/debian ./ || exit $?
  else
    cp -a ../../../reference-from-coq_8.5-2/debian ./ || exit $?
  fi
  mv -f debian-orig/* debian/ || exit $?
  rm -r debian-orig || exit $?
  if [ -e debian/coq.install.in -a "$(cat Makefile* configure* 2>/dev/null | grep -c coqworkmgr)" -eq 0 ]; then
    sed s'|usr/bin/coqworkmgr.||g' -i debian/coq.install.in || exit $?
  fi
  sed s"/COQ_VERSION := .*/COQ_VERSION := $i/g" -i debian/rules || exit $?
  sed s'/^Source: coq$/Source: '"$PKG"'/g' -i debian/control || exit $?
  for pkgname in coq coqide coq-theories libcoq-ocaml libcoq-ocaml-dev; do
    for f in "debian/${pkgname}".*; do
      if [ -e "$f" ]; then
        if [ "$f" != "debian/coqvars.mk.in" -a "$f" != "debian/coq.xpm" -a "$f" != "debian/coqide.desktop" ]; then
          mv "$f" "${f/${pkgname}/${PKG/coq/${pkgname}}}" || exit $?
        fi
      fi
    done
    sed s'|Recommends: '"$pkgname"' |Recommends: '"${PKG/coq/${pkgname}}"' |g' -i debian/control || exit $?
    sed s'/^Package: '"$pkgname"'$/Package: '"${PKG/coq/${pkgname}}"'/g' -i debian/control || exit $?
    sed s'|debian/'"$pkgname"'.install|debian/'"${PKG/coq/${pkgname}}"'.install|g' -i debian/rules || exit $?
    sed s'/ '"$pkgname"' (/ '"${PKG/coq/${pkgname}}"' (/g' -i debian/control || exit $?
  done
  sed s'/^\(\s*\)coq\( (= \${binary:Version})\)$/\1'"$PKG"'\2/g' -i debian/control || exit $?
  if [ "$(grep -R '{w|' . | grep -c '{w|')" -ne 0 ]; then
    if [ -e configure ]; then
      if [ "$(grep -c '3.11.2|3.12\*)' configure)" -ne 0 ]; then
        #sed s'|ocaml-nox (>= 4)|ocaml-nox (>= 3.11.2 \&\& << 4)|g' -i debian/control || exit $?
        sed s'|ocaml-nox (>= 4)|ocaml-nox (<< 4)|g' -i debian/control || exit $?
      elif [ "$(grep -c '3.11.2|3.12\*|4.\*)' configure)" -ne 0 ]; then
        #sed s'|ocaml-nox (>= 4)|ocaml-nox (>= 3.11.2 \&\& << 4.02.0)|g' -i debian/control || exit $?
        sed s'|ocaml-nox (>= 4)|ocaml-nox (<< 4.02.0)|g' -i debian/control || exit $?
      elif [ "$(grep -c '3.1\*)' configure)" -ne 0 ]; then
        #sed s'|ocaml-nox (>= 4)|ocaml-nox (>= 3.10 \&\& << 4)|g' -i debian/control || exit $?
        sed s'|ocaml-nox (>= 4)|ocaml-nox (<< 4)|g' -i debian/control || exit $?
      else
        sed s'|ocaml-nox (>= 4)|ocaml-nox (<< 4.02.0)|g' -i debian/control || exit $?
      fi
    else
      sed s'|ocaml-nox (>= 4)|ocaml-nox (<< 4.02.0)|g' -i debian/control || exit $?
    fi
  elif [ -e configure ]; then
    if [ "$(grep -c '3.11.2|3.12\*)' configure)" -ne 0 ]; then
      #sed s'|ocaml-nox (>= 4)|ocaml-nox (>= 3.11.2 \&\& << 4)|g' -i debian/control || exit $?
      sed s'|ocaml-nox (>= 4)|ocaml-nox (<< 4)|g' -i debian/control || exit $?
    elif [ "$(grep -c '3.11.2|3.12\*|4.\*)' configure)" -ne 0 ]; then
      #sed s'|ocaml-nox (>= 4)|ocaml-nox (>= 3.11.2 \&\& << 4.02.0)|g' -i debian/control || exit $?
      sed s'|ocaml-nox (>= 4)|ocaml-nox (<< 4.02.0)|g' -i debian/control || exit $?
    elif [ "$(grep -c '3.1\*)' configure)" -ne 0 ]; then
      #sed s'|ocaml-nox (>= 4)|ocaml-nox (>= 3.10 \&\& << 4)|g' -i debian/control || exit $?
      sed s'|ocaml-nox (>= 4)|ocaml-nox (<< 4)|g' -i debian/control || exit $?
    fi
  fi
  if [ -e configure.ml ]; then
    if [ "$(grep -c -- '-no-native-compiler' configure.ml)" -ne 0]; then
      sed s'|-native-compiler no|-no-native-compiler|g' -i debian/rules
    elif [ "$(grep -c -- '-native-compiler' configure.ml)" -eq 0]; then
      sed s'|-native-compiler no||g' -i debian/rules
    fi
  else
    sed s'|-native-compiler no||g' -i debian/rules
  fi
  if [ -e configure ]; then
    if [ "$(cat configure* | grep -c -- '--coqrunbyteflags')" -ne 0 ]; then
      sed s'|-debug |-debug --coqrunbyteflags "-dllib -lcoqrun" |g' -i debian/rules
    fi
    if [ "$(cat configure* | grep -c -- '-browser')" -eq 0 ]; then
      sed s'|-browser "[^"]*"||g' -i debian/rules
    fi
    if [ "$(cat configure* | grep -c -- '-with-doc')" -eq 0 ]; then
      sed s'|-with-doc no||g' -i debian/rules
    fi
    if [ "$(cat configure* | grep -c camlp5)" -eq 0 ]; then
      sed s'|camlp5 (>= 5.12-2~)|camlp4|g' -i debian/control
    fi
  fi
  if [[ "$i" != 8.5* ]]; then
    sed s'|ocaml-findlib (>= 1.4),|,|g' -i debian/control || exit $?
  fi
  if [ -e Makefile.build ]; then
    if [ "$(grep -c '/toploop' Makefile.build)" -eq 0 ]; then
      sed s'|chmod a-x debian/tmp/usr/lib/coq/toploop/\*cma|#|g' -i debian/rules
    fi
  fi
  cat >> debian/rules <<'EOF'

.PHONY: override_dh_auto_clean
override_dh_auto_clean:
	dh_auto_clean || make distclean -k || make clean -k || true

EOF
  if [ "$(find . -name "Makefile*" | xargs cat | grep -c '^\s*mkdirhier')" -ne 0 ]; then
    sed s'|Build-Depends:|Build-Depends: xutils-dev,|g' -i debian/control
  fi
  if [ "$(find . -name "configure*" | xargs cat | grep -c -- '-configdir')" -eq 0 ]; then
    sed s'|-configdir /etc/xdg/coq||g' -i debian/rules
  fi
  if [ ! -e configure -a ! -e configure.ml ]; then
    if [ -e Makefile ]; then
      if [ "$(grep -c '^configure:' Makefile 2>/dev/null)" -ne 0 ]; then
        sed s'|./configure $(CONFIGUREOPTS)|make configure|g' -i debian/rules
      fi
    elif [[ "$i" == 5.6* ]]; then
      sed s'|./configure $(CONFIGUREOPTS)|true|g' -i debian/rules
      cat >> debian/rules <<'EOF'

.PHONY: override_dh_auto_build
override_dh_auto_build:
	dh_auto_build || make -C SRC

EOF
    elif [[ "$i" == 5.8* ]]; then
      sed s'|./configure $(CONFIGUREOPTS)|true|g' -i debian/rules
      cat >> debian/rules <<'EOF'

.PHONY: override_dh_auto_build
override_dh_auto_build:
	dh_auto_build || (make -C LIB/libc; make -C LIB/stream-pp; make -C SRC)

EOF
    fi
  fi

  if [ ! -e 'test-suite/bugs/closed/4429.v' ]; then rm -f debian/patches/0003-Remove-test-4429.patch; fi
  if [ ! -e 'test-suite/bugs/closed/4366.v' ]; then rm -f debian/patches/0002-Remove-test-4366-too-picky-on-the-timeout.patch; fi
  if [ -e debian/patches/series ]; then
    (cd debian/patches && ls *.patch | sort) > debian/patches/series
  fi
  if [ ! -e 'test-suite/success/Nsatz.v' ]; then
    rm -rf debian/patches
  elif [ "$(grep -c 'Lemma Ceva' test-suite/success/Nsatz.v)" -eq 0 ]; then
    rm -rf debian/patches
  fi
  if [ "$i" == "8.5beta1" -o "$i" == "8.4pl6" ]; then # test-suite is broken
    sed s'/\(\$(MAKE) test-suite COMPLEXITY=\)/\1 || true/g' -i debian/rules
  fi
  popd
done
