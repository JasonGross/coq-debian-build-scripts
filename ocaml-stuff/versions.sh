#!/usr/bin/env bash

OCAML_BASE="ocaml_4.05.0-10ubuntu2"
HEVEA_BASE="hevea_2.32-1"
CAMLP5_BASE="camlp5_7.01-1build1"
LABLTK_BASE="labltk_8.06.2+dfsg-1"
LABLGL_BASE="lablgl_1.05-3"
LABLGTK2_BASE="lablgtk2_2.18.5+dfsg-1build1"
LABLGTK3_BASE="lablgtk3_3.0~beta3-1"
GTK3SPELL_BASE="gtkspell3_3.0.4-1"
OCAMLGRAPH_BASE="ocamlgraph_1.8.6-1build5"
DUNE_BASE="dune_1.0~beta20-1"
#OCAML_RE_BASE="ocaml-re_1.7.3-2"
CMDLINER_BASE="cmdliner_1.0.2-1"
UUTF_BASE="uutf_1.0.1-2"
CAMLBZ2_BASE="camlbz2_0.6.0-7build2"
CAMLZIP_BASE="camlzip_1.07-2"
CPPO_BASE="cppo_1.5.0-2build2"
LIBZSTD_BASE="libzstd_1.3.5+dfsg-1ubuntu1"
RPM_BASE="rpm_4.14.1+dfsg1-4"
OCAML_ZARITH_BASE="ocaml-zarith_1.8-1"

NEW_SOURCE_EXTRA="-s xenial" # "-s eoan" # "-s cosmic"

PRECISE_PKGS=""
XENIAL_PKGS=""
PKGS="" # "ocaml-zarith"

#PRECISE_PKGS="libiberty"
#PRECISE_PKGS="lz4"

#DSCS="${LIBZSTD_BASE}.dsc" # might actually only need to be on precise; is only needed for rpm, I think

#DSCS="${RPM_BASE}.dsc"

#DSCS="${OCAML_BASE}.dsc" # needed only for removing versioned provides

#PKGS="findlib"

#PKGS="ocamlbuild"

#PKGS="labltk camlp4"
#DSCS="${HEVEA_BASE}.dsc ${CAMLP5_BASE}.dsc"

### DSCS="${LABLTK_BASE}.dsc" # doesn't need this

#DSCS="${LABLGL_BASE}.dsc"

#PKGS="lablgtk2"
#DSCS="${GTK3SPELL_BASE}.dsc"
#DSCS="" # "${LABLGTK3_BASE}.dsc"

DSCS="${OCAML_ZARITH_BASE}.dsc"

#PKGS="ocamlgraph

#PKGS="ocaml-result ounit"
#DSCS="${DUNE_BASE}.dsc"

#PKGS="ocaml-re"
#DSCS="${CMDLINER_BASE}.dsc ${UUTF_BASE}.dsc ${CAMLBZ2_BASE}.dsc ${CAMLZIP_BASE}.dsc ${CPPO_BASE}.dsc"

#PKGS="extlib"

#PKGS="jsonm cudf"

#PKGS="dose3"

#PKGS="opam"


### DSCS="${LABLGTK2_BASE}.dsc" # doesn't need this
### DSCS="${OCAMLGRAPH_BASE}.dsc" # doesn't need this

PPA="coq-master-daily" #"coq-8.10-daily" #"coq-master-daily" # "test-coq-new-ocaml-temp1"
SUFFIX="~ppa8"
PPA_EXT=".1~${TARGET}${SUFFIX}"

function extra_uploads() {
    for i in ${PKGS}; do
        backportpackage -y -u ppa:jgross-h/${PPA} $i -d $TARGET -S $SUFFIX ${NEW_SOURCE_EXTRA}
    done
    if [ "${TARGET}" == "precise" ]; then
        for i in ${PRECISE_PKGS}; do
            backportpackage -y -u ppa:jgross-h/${PPA} $i -d $TARGET -S $SUFFIX ${NEW_SOURCE_EXTRA}
        done
    fi
    if [ "${TARGET}" == "xenial" ]; then
        for i in ${XENIAL_PKGS}; do
            backportpackage -y -u ppa:jgross-h/${PPA} $i -d $TARGET -S $SUFFIX ${NEW_SOURCE_EXTRA}
        done
    fi
}


function make_urls() {
    for i in ${DSCS}; do
        BASE="${i%.dsc}"
        URL_BASE="http://archive.ubuntu.com/ubuntu/pool/universe/${i:0:1}/${i%%_*}/"
        if [[ "${i}" == "libzstd_"* ]]; then
            URL_BASE="http://archive.ubuntu.com/ubuntu/pool/main/libz/${i%%_*}/"
        elif [[ "${i}" == "gtkspell3"* ]]; then
            URL_BASE="http://archive.ubuntu.com/ubuntu/pool/main/${i:0:1}/${i%%_*}/"
        fi
        echo "${URL_BASE}${BASE}.dsc"
        if [[ "${i}" == "gtkspell3"* ]]; then
            echo "${URL_BASE}${BASE}.debian.tar.gz"
        else
            echo "${URL_BASE}${BASE}.debian.tar.xz"
        fi
        if [[ "${i}" == "ocaml_"* ]] || [[ "${i}" == "libzstd_"* ]]; then
            echo "${URL_BASE}${BASE%-*}.orig.tar.xz"
        elif [[ "${i}" == "dune_"* ]] || [[ "${i}" == "cmdliner_"* ]] || [[ "${i}" == "rpm_"* ]]; then
            echo "${URL_BASE}${BASE%-*}.orig.tar.bz2"
        else
            echo "${URL_BASE}${BASE%-*}.orig.tar.gz"
        fi
    done
}

URLS="$(make_urls)"

if [ -z "$TARGET" ]; then
  TARGET=trusty # precise #
fi

function to_folder_name() {
    FOLDER="$1"
    #FOLDER="${FOLDER%.debian.tar.xz}"
    FOLDER="${FOLDER%-*}"
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
