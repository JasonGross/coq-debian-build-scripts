#!/usr/bin/env bash
#./02-make-debian-preorigs.sh && ./03-sanitize-debian-origs.sh
NO_ORIG_SOURCE="" # "-no-orig-source" # ""
for TARGET in hirsute groovy focal bionic xenial trusty precise; do export TARGET; ./04-make-debian-from-reference.sh && ./05-build-debian-only-source${NO_ORIG_SOURCE}.sh && ./06-try-dput.sh; done && ./bump-version.sh && git commit -am "Bump version" && git push
#for TARGET in hirsute groovy focal; do export TARGET; ./04-make-debian-from-reference.sh && ./05-build-debian-only-source.sh && ./06-try-dput.sh; done && ./bump-version.sh && git commit -am "Bump version" && git push
