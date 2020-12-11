#!/usr/bin/env bash
#for TARGET in hirsute groovy focal bionic xenial trusty precise; do export TARGET; ./04-make-debian-from-reference.sh && ./05-build-debian-only-source.sh && ./06-try-dput.sh; done && ./bump-version.sh && git commit -am "Bump version" && git push
for TARGET in hirsute focal; do export TARGET; ./04-make-debian-from-reference.sh && ./05-build-debian-only-source.sh && ./06-try-dput.sh; done && ./bump-version.sh && git commit -am "Bump version" && git push
