#!/usr/bin/env bash
#./02-make-debian-preorigs.sh && ./03-sanitize-debian-origs.sh
NO_ORIG_SOURCE="" # "-no-orig-source" # ""
TARGETS="hirsute groovy focal bionic xenial trusty precise" # "hirsute groovy xenial"
for TARGET in $TARGETS; do export TARGET; ./04-make-debian-from-reference.sh && ./05-build-debian-only-source${NO_ORIG_SOURCE}.sh && ./06-try-dput.sh || exit $?; done && ./bump-version.sh && git commit -am "Bump version" && git push
