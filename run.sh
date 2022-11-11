#!/usr/bin/env bash
#./02-make-debian-preorigs.sh && ./03-sanitize-debian-origs.sh
NO_ORIG_SOURCE="" # "-no-orig-source" # ""
TARGETS="lunar kinetic jammy focal bionic xenial trusty"
NEW_PPAS="many-coq-versions-ocaml-4-08 many-coq-versions-ocaml-4-11"
for NEW_PPA in ${NEW_PPAS}; do export NEW_PPA; export VER_LT_8_14_PPA="${NEW_PPA}"; for TARGET in $TARGETS; do export TARGET; ./04-make-debian-from-reference.sh && ./05-build-debian-only-source${NO_ORIG_SOURCE}.sh && ./06-try-dput.sh || exit $?; done && ./bump-version.sh && git commit -am "Bump version" && git push; done
