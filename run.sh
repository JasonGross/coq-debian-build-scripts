#!/bin/bash

for TARGET in trusty precise; do
    export TARGET=$TARGET
    ./04-make-debian-from-reference.sh && ./05-build-debian-only-source.sh && ./06-try-dput.sh
done
./bump-version.sh
