#!/bin/bash

ARGS=""
if [ $# -ne 0 ]; then
    ARGS="--show-progress"
fi

sudo apt-get install "$@" $ARGS git build-essential devscripts debhelper dh-ocaml ocaml-nox ocaml-best-compilers ocaml-findlib camlp5 liblablgtk2-ocaml-dev liblablgtksourceview2-ocaml-dev texlive-latex-extra hevea
