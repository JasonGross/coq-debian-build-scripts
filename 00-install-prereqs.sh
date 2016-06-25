#!/bin/bash

ARGS=""
if [ $# -ne 0 ]; then
    ARGS="--show-progress"
fi

sudo apt-get install "$@" $ARGS git dch
