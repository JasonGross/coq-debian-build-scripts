#!/usr/bin/env bash
#for TARGET in trusty precise cosmic bionic artful xenial; do export TARGET; ./04-make-debian-from-reference.sh && ./05-build-debian-only-source.sh && ./06-try-dput.sh; done && ./bump-version.sh && git commit -am "Bump version" && git push
#for TARGET in precise trusty xenial; do export TARGET; ./02-make-debian.sh && ./03-build-debian-only-source.sh && ./04-try-dput.sh; done # && ./bump-version.sh && git commit -am "Bump version" && git push
TARGETS="precise" # "groovy focal bionic xenial trusty" # "focal groovy" # "bionic xenial precise trusty" # "focal groovy bionic xenial precise trusty" # "xenial" # "xenial precise trusty" # "xenial" # "precise trusty" # "precise" # "bionic cosmic" # "precise trusty xenial" # "precise"
for TARGET in $TARGETS ; do export TARGET; ./02-make-debian.sh && ./03-build-debian-only-source.sh && ./04-try-dput.sh || exit $?; done # && ./bump-version.sh && git commit -am "Bump version" && git push
#TARGETS="xenial precise trusty" # "xenial" # "precise trusty" # "precise" # "bionic cosmic" # "precise trusty xenial" # "precise"
#for TARGET in $TARGETS ; do export TARGET; ./04-try-dput.sh; done # && ./bump-version.sh && git commit -am "
