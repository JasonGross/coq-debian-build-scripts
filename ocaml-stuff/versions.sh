#!/usr/bin/env bash

OCAML_BASE="ocaml_4.05.0-10ubuntu2"
HEVEA_BASE="hevea_2.32-1"
CAMLP5_BASE="camlp5_7.01-1build1"
LABLTK_BASE="labltk_8.06.2+dfsg-1"
LABLGL_BASE="lablgl_1.05-3"
LABLGTK2_BASE="lablgtk2_2.18.5+dfsg-1build1"
OCAMLGRAPH_BASE="ocamlgraph_1.8.6-1build5"

DSCS="${OCAML_BASE}.dsc" # needed only for removing versioned provides
#DSCS="${HEVEA_BASE}.dsc ${CAMLP5_BASE}.dsc"
### DSCS="${LABLTK_BASE}.dsc" # doesn't need this
#DSCS="${LABLGL_BASE}.dsc"
### DSCS="${LABLGTK2_BASE}.dsc" # doesn't need this
### DSCS="${OCAMLGRAPH_BASE}.dsc" # doesn't need this

function make_urls() {
    for i in ${DSCS}; do
        BASE="${i%.dsc}"
        URL_BASE="http://archive.ubuntu.com/ubuntu/pool/universe/${i:0:1}/${i%%_*}/"
        echo "${URL_BASE}${BASE}.dsc"
        echo "${URL_BASE}${BASE}.debian.tar.xz"
        if [[ "${i}" == "ocaml_"* ]]; then
            echo "${URL_BASE}${BASE%%-*}.orig.tar.xz"
        else
            echo "${URL_BASE}${BASE%%-*}.orig.tar.gz"
        fi
    done
}

URLS="$(make_urls)"

if [ -z "$TARGET" ]; then
  TARGET=trusty # precise #
fi

PPA_EXT=".1~${TARGET}~ppa1"

function to_folder_name() {
    FOLDER="$1"
    #FOLDER="${FOLDER%.debian.tar.xz}"
    FOLDER="${FOLDER%%-*}"
    FOLDER="${FOLDER//_/-}"
    echo "${FOLDER}"
}

function to_preversion() {
    VERSION="$1"
    VERSION="${VERSION%.dsc}"
    VERSION="${VERSION##*_}"
    echo "${VERSION}"
}

function to_version() {
    VERSION="$(to_preversion "$1")"
    echo "${VERSION}${PPA_EXT}"
}

function to_changes() {
    CHANGES="$1"
    CHANGES="${CHANGES%.dsc}"
    CHANGES="${CHANGES}${PPA_EXT}_source.changes"
    echo "${CHANGES}"
}

PPA="test-coq-new-ocaml-temp1"
