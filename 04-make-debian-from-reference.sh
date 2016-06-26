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
  cp -a ../../../reference-from-coq_8.5-2/debian ./ || exit $?
  mv -f debian-orig/* debian/ || exit $?
  rm -r debian-orig || exit $?
  if [ "$(cat Makefile* configure* 2>/dev/null | grep -c coqworkmgr)" -eq 0 ]; then
    sed s'|usr/bin/coqworkmgr.||g' -i debian/coq.install.in || exit $?
  fi
  sed s"/COQ_VERSION := .*/COQ_VERSION := $i/g" -i debian/rules || exit $?
  sed s'/^Source: coq$/Source: '"$PKG"'/g' -i debian/control || exit $?
  if [[ "$i" == 8.4* ]]; then
    cat > debian/libcoq-ocaml-dev.install.in <<'EOF'
usr/bin/coqmktop*
usr/share/man/man1/coqmktop*
usr/lib/coq/proofs/proofs.cma
usr/lib/coq/ide/ide.cma
usr/lib/coq/interp/interp.cma
usr/lib/coq/tactics/tactics.cma
usr/lib/coq/tactics/hightactics.cma
usr/lib/coq/lib/lib.cma
usr/lib/coq/toplevel/toplevel.cma
usr/lib/coq/parsing/highparsing.cma
usr/lib/coq/parsing/grammar.cma
usr/lib/coq/parsing/parsing.cma
usr/lib/coq/pretyping/pretyping.cma
usr/lib/coq/library/library.cma
usr/lib/coq/kernel/kernel.cma
usr/lib/coq/config/coq_config.cmo
# other *.cm* files will be added here by debian/rules
EOF
    cat > debian/libcoq-ocaml.install.in <<'EOF'
usr/lib/coq/dllcoqrun.so @OCamlDllDir@
usr/lib/coq/plugins/ring/ring_plugin.cma
usr/lib/coq/plugins/fourier/fourier_plugin.cma
usr/lib/coq/plugins/extraction/extraction_plugin.cma
usr/lib/coq/plugins/omega/omega_plugin.cma
usr/lib/coq/plugins/cc/cc_plugin.cma
usr/lib/coq/plugins/syntax/string_syntax_plugin.cma
usr/lib/coq/plugins/syntax/nat_syntax_plugin.cma
usr/lib/coq/plugins/syntax/numbers_syntax_plugin.cma
usr/lib/coq/plugins/syntax/z_syntax_plugin.cma
usr/lib/coq/plugins/syntax/r_syntax_plugin.cma
usr/lib/coq/plugins/syntax/ascii_syntax_plugin.cma
usr/lib/coq/plugins/funind/recdef_plugin.cma
usr/lib/coq/plugins/nsatz/nsatz_plugin.cma
usr/lib/coq/plugins/xml/xml_plugin.cma
usr/lib/coq/plugins/romega/romega_plugin.cma
usr/lib/coq/plugins/firstorder/ground_plugin.cma
usr/lib/coq/plugins/subtac/subtac_plugin.cma
usr/lib/coq/plugins/field/field_plugin.cma
usr/lib/coq/plugins/rtauto/rtauto_plugin.cma
usr/lib/coq/plugins/setoid_ring/newring_plugin.cma
usr/lib/coq/plugins/micromega/micromega_plugin.cma
usr/lib/coq/plugins/quote/quote_plugin.cma
usr/lib/coq/plugins/decl_mode/decl_mode_plugin.cma
DYN: usr/lib/coq/plugins/ring/ring_plugin.cmxs
DYN: usr/lib/coq/plugins/fourier/fourier_plugin.cmxs
DYN: usr/lib/coq/plugins/extraction/extraction_plugin.cmxs
DYN: usr/lib/coq/plugins/omega/omega_plugin.cmxs
DYN: usr/lib/coq/plugins/cc/cc_plugin.cmxs
DYN: usr/lib/coq/plugins/syntax/string_syntax_plugin.cmxs
DYN: usr/lib/coq/plugins/syntax/nat_syntax_plugin.cmxs
DYN: usr/lib/coq/plugins/syntax/numbers_syntax_plugin.cmxs
DYN: usr/lib/coq/plugins/syntax/z_syntax_plugin.cmxs
DYN: usr/lib/coq/plugins/syntax/r_syntax_plugin.cmxs
DYN: usr/lib/coq/plugins/syntax/ascii_syntax_plugin.cmxs
DYN: usr/lib/coq/plugins/funind/recdef_plugin.cmxs
DYN: usr/lib/coq/plugins/nsatz/nsatz_plugin.cmxs
DYN: usr/lib/coq/plugins/xml/xml_plugin.cmxs
DYN: usr/lib/coq/plugins/romega/romega_plugin.cmxs
DYN: usr/lib/coq/plugins/firstorder/ground_plugin.cmxs
DYN: usr/lib/coq/plugins/subtac/subtac_plugin.cmxs
DYN: usr/lib/coq/plugins/field/field_plugin.cmxs
DYN: usr/lib/coq/plugins/rtauto/rtauto_plugin.cmxs
DYN: usr/lib/coq/plugins/setoid_ring/newring_plugin.cmxs
DYN: usr/lib/coq/plugins/micromega/micromega_plugin.cmxs
DYN: usr/lib/coq/plugins/quote/quote_plugin.cmxs
DYN: usr/lib/coq/plugins/decl_mode/decl_mode_plugin.cmxs
EOF
    cat > debian/coqide.install <<'EOF'
usr/bin/coqide*
usr/share/coq/coq.png
etc/xdg/coq/coqide-gtk2rc
usr/share/doc/coq/FAQ-CoqIde usr/share/doc/coqide
usr/share/man/man1/coqide*
debian/coqide.desktop    usr/share/applications
EOF
  fi
  if [[ "$i" == 8.3* ]]; then
    cat > debian/libcoq-ocaml-dev.install.in <<'EOF'
usr/bin/coqmktop*
usr/share/man/man1/coqmktop*
usr/lib/coq/proofs/proofs.cma
usr/lib/coq/ide/ide.cma
usr/lib/coq/interp/interp.cma
usr/lib/coq/tactics/tactics.cma
usr/lib/coq/tactics/hightactics.cma
usr/lib/coq/lib/lib.cma
usr/lib/coq/toplevel/toplevel.cma
usr/lib/coq/parsing/highparsing.cma
usr/lib/coq/parsing/grammar.cma
usr/lib/coq/parsing/parsing.cma
usr/lib/coq/pretyping/pretyping.cma
usr/lib/coq/library/library.cma
usr/lib/coq/kernel/kernel.cma
usr/lib/coq/config/coq_config.cmo
# other *.cm* files will be added here by debian/rules
EOF
    cat > debian/libcoq-ocaml.install.in <<'EOF'
usr/lib/coq/dllcoqrun.so @OCamlDllDir@
usr/lib/coq/plugins/ring/ring_plugin.cma
usr/lib/coq/plugins/fourier/fourier_plugin.cma
usr/lib/coq/plugins/extraction/extraction_plugin.cma
usr/lib/coq/plugins/omega/omega_plugin.cma
usr/lib/coq/plugins/cc/cc_plugin.cma
usr/lib/coq/plugins/syntax/string_syntax_plugin.cma
usr/lib/coq/plugins/syntax/nat_syntax_plugin.cma
usr/lib/coq/plugins/syntax/numbers_syntax_plugin.cma
usr/lib/coq/plugins/syntax/z_syntax_plugin.cma
usr/lib/coq/plugins/syntax/r_syntax_plugin.cma
usr/lib/coq/plugins/syntax/ascii_syntax_plugin.cma
usr/lib/coq/plugins/funind/recdef_plugin.cma
usr/lib/coq/plugins/nsatz/nsatz_plugin.cma
usr/lib/coq/plugins/xml/xml_plugin.cma
usr/lib/coq/plugins/dp/dp_plugin.cma
usr/lib/coq/plugins/romega/romega_plugin.cma
usr/lib/coq/plugins/firstorder/ground_plugin.cma
usr/lib/coq/plugins/subtac/subtac_plugin.cma
usr/lib/coq/plugins/field/field_plugin.cma
usr/lib/coq/plugins/rtauto/rtauto_plugin.cma
usr/lib/coq/plugins/setoid_ring/newring_plugin.cma
usr/lib/coq/plugins/micromega/micromega_plugin.cma
usr/lib/coq/plugins/quote/quote_plugin.cma
DYN: usr/lib/coq/plugins/ring/ring_plugin.cmxs
DYN: usr/lib/coq/plugins/fourier/fourier_plugin.cmxs
DYN: usr/lib/coq/plugins/extraction/extraction_plugin.cmxs
DYN: usr/lib/coq/plugins/omega/omega_plugin.cmxs
DYN: usr/lib/coq/plugins/cc/cc_plugin.cmxs
DYN: usr/lib/coq/plugins/syntax/string_syntax_plugin.cmxs
DYN: usr/lib/coq/plugins/syntax/nat_syntax_plugin.cmxs
DYN: usr/lib/coq/plugins/syntax/numbers_syntax_plugin.cmxs
DYN: usr/lib/coq/plugins/syntax/z_syntax_plugin.cmxs
DYN: usr/lib/coq/plugins/syntax/r_syntax_plugin.cmxs
DYN: usr/lib/coq/plugins/syntax/ascii_syntax_plugin.cmxs
DYN: usr/lib/coq/plugins/funind/recdef_plugin.cmxs
DYN: usr/lib/coq/plugins/nsatz/nsatz_plugin.cmxs
DYN: usr/lib/coq/plugins/xml/xml_plugin.cmxs
DYN: usr/lib/coq/plugins/dp/dp_plugin.cmxs
DYN: usr/lib/coq/plugins/romega/romega_plugin.cmxs
DYN: usr/lib/coq/plugins/firstorder/ground_plugin.cmxs
DYN: usr/lib/coq/plugins/subtac/subtac_plugin.cmxs
DYN: usr/lib/coq/plugins/field/field_plugin.cmxs
DYN: usr/lib/coq/plugins/rtauto/rtauto_plugin.cmxs
DYN: usr/lib/coq/plugins/setoid_ring/newring_plugin.cmxs
DYN: usr/lib/coq/plugins/micromega/micromega_plugin.cmxs
DYN: usr/lib/coq/plugins/quote/quote_plugin.cmxs
EOF
    cat > debian/coqide.install <<'EOF'
usr/bin/coqide*
usr/lib/coq/ide/coq.png
usr/lib/coq/ide/.coqide-gtk2rc
usr/lib/coq/ide/FAQ
usr/share/man/man1/coqide*
debian/coqide.desktop    usr/share/applications
EOF
  fi
  for pkgname in coq coqide coq-theories libcoq-ocaml libcoq-ocaml-dev; do
    for f in "debian/${pkgname}".*; do
      if [ "$f" != "debian/coqvars.mk.in" -a "$f" != "debian/coq.xpm" -a "$f" != "debian/coqide.desktop" ]; then
        mv "$f" "${f/${pkgname}/${PKG/coq/${pkgname}}}" || exit $?
      fi
    done
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
    if [ "$(grep -c -- '--coqrunbyteflags' configure)" -ne 0 ]; then
      sed s'|-debug |-debug --coqrunbyteflags "-dllib -lcoqrun" "-dllib -lcoqrun" |g' -i debian/rules
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
  if [ "$(find . -name "configure*" | xargs cat | grep -c -- '-configdir')" -eq 0 ]; then
    sed s'|-configdir /etc/xdg/coq||g' -i debian/rules
  fi
  if [ ! -e configure -a -e Makefile ]; then
    if [ "$(grep -c '^configure:' Makefile 2>/dev/null)" -ne 0 ]; then
      sed s'|./configure $(CONFIGUREOPTS)|make configure|g' -i debian/rules
    fi
  fi

  if [ ! -e 'test-suite/bugs/closed/4429.v' ]; then rm -f debian/patches/0003-Remove-test-4429.patch; fi
  if [ ! -e 'test-suite/bugs/closed/4366.v' ]; then rm -f debian/patches/0002-Remove-test-4366-too-picky-on-the-timeout.patch; fi
  (cd debian/patches && ls *.patch | sort) > debian/patches/series
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
