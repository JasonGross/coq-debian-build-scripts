#!/usr/bin/env bash

set -ex

. versions.sh

cd debian-sources

for i in $DSCS; do
    FOLDER="$(to_folder_name "$i")"
    CHANGES="$(to_changes "$i")"
    dput ppa:jgross-h/$PPA "$CHANGES"
    #sleep 2m
done
