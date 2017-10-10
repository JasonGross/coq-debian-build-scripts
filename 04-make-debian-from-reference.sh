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
  if [[ "$i" == 8.6* ]]; then
    cp -a ../../../reference-from-coq_8.6-8.5/debian ./ || exit $?
  elif [[ "$i" == 8.5* ]]; then
    cp -a ../../../reference-from-coq_8.5-2/debian ./ || exit $?
  elif [[ "$i" == 8.4* ]]; then
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
    cp -a ../../../reference-from-coq_8.7-8.5/debian ./ || exit $?
  fi
  mv -f debian-orig/* debian/ || exit $?
  rm -r debian-orig || exit $?
  if [ -e debian/coq.install.in -a "$(cat Makefile* configure* 2>/dev/null | grep -c coqworkmgr)" -eq 0 ]; then
    sed s'|usr/bin/coqworkmgr.||g' -i debian/coq.install.in || exit $?
  fi
  sed s'|^override_dh_auto_install:$|override_dh_auto_install::|g' -i debian/rules
  cat >> debian/rules <<'EOF'

.PHONY: override_dh_auto_clean
override_dh_auto_clean:
	dh_auto_clean || make distclean -k || make clean -k || true

#override_dh_auto_install::
#	find debian/tmp -name '*.cmxs' -printf '%P\n' \
#	  >> debian/coq-theories.install
EOF
  if [ "$i" == "8.4beta" ]; then
    cat >> debian/rules <<'EOF'

override_dh_auto_install::
	find debian/tmp -name '*.cma' -printf '%P\n' \
	  >> debian/coq-theories.install
EOF
  fi
  if [[ "$i" == 8.6beta1 ]]; then
    sed s'/..MAKE. test-suite COMPLEXITY=/#/g' -i debian/rules || exit $?
  fi
  if [[ "$i" == 8.7* ]]; then
    sed s',usr/lib/coq/tools/compat5.cmo,,g' -i debian/*.install* || exit $?
    cat >> debian/coq.install.in <<EOF
usr/lib/coq/tools/CoqMakefile.in
usr/lib/coq/tools/TimeFileMaker.py
usr/lib/coq/tools/make-both-time-files.py
usr/lib/coq/tools/make-one-time-file.py
usr/lib/coq/tools/make-both-single-timing-files.py
EOF
    sed s'/Build-Depends:/Build-Depends: rsync,/g' -i debian/control || exit $?
    sed s'/\(coq-theories (= \${binary:Version}),\)/\1 libcoq-ocaml (= ${binary:Version}),/g' -i debian/control || exit $?
    sed s',usr/share/emacs/site-lisp/coqdoc.sty\s*usr/share/texmf/tex/latex/misc/,usr/share/texmf/tex/latex/misc/coqdoc.sty,g' -i debian/*.install* || exit $?
    sed s',usr/lib/coq/dllcoqrun.so,usr/lib/coq/kernel/byterun/dllcoqrun.so,g' -i debian/*.install* || exit $?
    sed s',usr/lib/coq/tools/compat5.cmo,usr/lib/coq/grammar/compat5.cmo,g' -i debian/*.install* || exit $?
    sed s',usr/lib/coq/grammar/compat5.cmo,,g' -i debian/*.install* || exit $?
    sed s",| grep -v 'grammar/compat5.cmo',,g" -i debian/rules || exit $?
    #echo 'usr/lib/coq/META' >> debian/libcoq-ocaml.install.in || exit $?
    #cp debian/libcoq-ocaml.install.in debian/libcoq-ocaml.install.in.tmp
    #grep -v quote_plugin debian/libcoq-ocaml.install.in.tmp > debian/libcoq-ocaml.install.in
    sed s'/^README$/README.md/g' -i debian/docs || exit $?
    sed s'/test-suite /test-suite APPVEYOR=1 /g' -i debian/rules || exit $?
  fi
  if [[ "$i" == 8.6* ]]; then
    sed s',usr/lib/coq/tools/compat5.cmo,usr/lib/coq/grammar/compat5.cmo,g' -i debian/*.install* || exit $?
    #echo 'usr/lib/coq/META' >> debian/libcoq-ocaml.install.in || exit $?
    #cp debian/libcoq-ocaml.install.in debian/libcoq-ocaml.install.in.tmp
    #grep -v quote_plugin debian/libcoq-ocaml.install.in.tmp > debian/libcoq-ocaml.install.in
    sed s'/^README$/README.md/g' -i debian/docs || exit $?
  fi
  sed s"/COQ_VERSION := .*/COQ_VERSION := $i/g" -i debian/rules || exit $?
  sed s'/^Source: coq$/Source: '"$PKG"'/g' -i debian/control || exit $?
  for pkgname in coq coqide coq-theories libcoq-ocaml libcoq-ocaml-dev; do
    new_pkgname="$(to_package_name "${pkgname}" "$i")"
    for f in "debian/${pkgname}".*; do
      if [ -e "$f" ]; then
        if [ "$f" != "debian/coqvars.mk.in" -a "$f" != "debian/coq.xpm" -a "$f" != "debian/coqide.desktop" ]; then
          mv "$f" "${f/${pkgname}/${new_pkgname}}" || exit $?
        fi
      fi
    done
    sed s'|Recommends: '"$pkgname"' |Recommends: '"${new_pkgname}"' |g' -i debian/control || exit $?
    sed s'/^Package: '"$pkgname"'$/Package: '"${new_pkgname}"'/g' -i debian/control || exit $?
    sed s'|debian/'"$pkgname"'.install|debian/'"${new_pkgname}"'.install|g' -i debian/rules || exit $?
    sed s'/ '"$pkgname"' (/ '"${new_pkgname}"' (/g' -i debian/control || exit $?
    sed s'/ '"$pkgname"',/ '"${new_pkgname}"',/g' -i debian/control || exit $?
  done
  sed s'/^\(\s*\)coq\( (= \${binary:Version})\)$/\1'"$PKG"'\2/g' -i debian/control || exit $?
  sed s'|\(cp debian/coq.xpm \)\(.*\)\(/coqide.xpm\)|mkdir -p \2 \&\& \1\2\3|g' -i debian/rules || exit $?
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
    if [ "$(grep -c -- '-no-native-compiler' configure.ml)" -ne 0 ]; then
      sed s'|-native-compiler no|-no-native-compiler|g' -i debian/rules
    elif [ "$(grep -c -- '-native-compiler' configure.ml)" -eq 0 ]; then
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
  if [[ "$i" == 8.4* ]] || [[ "$i" == 8.3* ]] || [[ "$i" == 8.2* ]] || [[ "$i" == 8.1* ]] || [[ "$i" == 8.0* ]] || [[ "$i" == 7.* ]] || [[ "$i" == 6.* ]] || [[ "$i" == 5.* ]]; then
    if [ "$TARGET" == precise ]; then
          sed s'|ocaml-findlib (>= 1.4),|ocaml-findlib (>= 1.2),|g' -i debian/control || exit $?
    fi
  fi
  if [ -e Makefile.build ]; then
    if [ "$(grep -c '/toploop' Makefile.build)" -eq 0 ]; then
      sed s'|chmod a-x debian/tmp/usr/lib/coq/toploop/\*cma|#|g' -i debian/rules
    fi
  fi
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
  if [[ "$i" == "8.7+beta1" ]] || [[ "$i" == "8.7+beta2" ]]; then # test-suite is broken without git
    sed s'/\(..MAKE. test-suite .*\)/\1 || true/g' -i debian/rules || exit $?
  fi
  if [ "$i" == "8.5beta1" -o \( "$i" == "8.5beta2" -a "$TARGET" == "precise" \) -o "$i" == "8.4pl6" ]; then # test-suite is broken
    sed s'/\(\$(MAKE) test-suite COMPLEXITY=\)/\1 || true/g' -i debian/rules
    sed s'~\(\$(MAKE) check COMPLEXITY= BESTCHICKEN=/bin/true\)~\1 || true~g' -i debian/rules
  fi
  popd
done
