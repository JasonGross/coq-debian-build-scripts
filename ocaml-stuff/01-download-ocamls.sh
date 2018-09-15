#!/bin/bash

set -ex

. versions.sh

mkdir -p debian-sources
cd debian-sources

for i in ${URLS}; do
    wget -N "$i" || exit $?
done
