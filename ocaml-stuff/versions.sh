#!/usr/bin/env bash

BINUTILS_BASE="binutils_2.24-5ubuntu3" # "binutils_2.26.1-1ubuntu1~16.04.8"
OCAML_BASE="ocaml_4.11.1-4" # "ocaml_4.08.1-8" # "ocaml_4.05.0-10ubuntu2"
HEVEA_BASE="hevea_2.32-3build1"
HEVEA_groovy_BASE="hevea_2.34-2build2"
CAMLP5_BASE="camlp5_7.01-1build1"
CAMLP5_4_11_BASE="camlp5_7.13-1"
LABLTK_BASE="labltk_8.06.2+dfsg-1"
LABLGL_BASE="lablgl_1.05-3"
LABLGTK2_BASE="lablgtk2_2.18.5+dfsg-1build1"
LABLGTK3_BASE="lablgtk3_3.1.2-1"
GTK3SPELL_BASE="gtkspell3_3.0.4-1"
OCAMLBUILD_BASE="ocamlbuild_0.14.0-1build3"
OCAMLBUILD_groovy_BASE="ocamlbuild_0.14.0-2"
OCAMLGRAPH_BASE="ocamlgraph_1.8.6-1build5"
OCAML_DUNE_BASE="ocaml-dune_3.11.1-1build1"
OCAML_CSEXP_BASE="ocaml-csexp_1.5.1-1build1"
#OCAML_RE_BASE="ocaml-re_1.7.3-2"
CMDLINER_BASE="cmdliner_1.0.2-1"
UUTF_BASE="uutf_1.0.1-2"
CAMLBZ2_BASE="camlbz2_0.6.0-7build2"
CAMLZIP_BASE="camlzip_1.07-2"
CPPO_BASE="cppo_1.5.0-2build2"
LIBZSTD_BASE="libzstd_1.3.5+dfsg-1ubuntu1"
RPM_BASE="rpm_4.14.1+dfsg1-4"
OCAML_ZARITH_BASE="ocaml-zarith_1.11-1"
FINDLIB_BASE="findlib_1.8.1-2" # "findlib_1.8.1-1build3"
GCC_DEFAULTS_BASE="gcc-defaults_1.150ubuntu1"
OCAML_GRAPHICS_BASE="ocaml-graphics_5.1.0-2"
OCAML_NUM_BASE="ocaml-num_1.3-1"
OCAML_CAIRO2_focal_BASE="ocaml-cairo2_0.6.1+dfsg-3"
OCAML_CAIRO2_groovy_BASE="ocaml-cairo2_0.6.1+dfsg-5build1"
CAMLP_STREAMS_BASE="camlp-streams_5.0-1"

NEW_SOURCE_EXTRA="-s focal" # "-s hirsute" # "-s sid" # "-s groovy" # "-s xenial" # "-s groovy" # "-s xenial" # "-s eoan" # "-s cosmic"

PRECISE_PKGS=""
XENIAL_PKGS=""
PKGS="" # "lablgtk3" # "ocaml-zarith"
DSCS="" # "${OCAML_ZARITH_BASE}.dsc"
DEBIAN_DSCS="" # "${OCAML_ZARITH_BASE}.dsc"

DEBUILD_SA_DSCS="" # "${OCAML_ZARITH_BASE}.dsc"

#if [ "${TARGET}" == "hirsute" ] || [ "${TARGET}" == "groovy" ] || [ "${TARGET}" == "focal" ]; then
#    NEW_SOURCE_EXTRA="-s ${TARGET}"
#    PKGS="ocaml-num"
#else
#    DSCS="${OCAML_NUM_BASE}.dsc"
#fi

#if [ "${TARGET}" == "groovy" ] || [ "${TARGET}" == "focal" ]; then
#    dsc1="OCAML_CAIRO2_${TARGET}_BASE"
#    DSCS="${CAMLP5_4_11_BASE}.dsc ${!dsc1}.dsc ${OCAML_GRAPHICS_BASE}.dsc"
#else
#    DSCS="${CAMLP5_BASE}.dsc ${OCAML_GRAPHICS_BASE}.dsc"
#fi

#if [ "${TARGET}" == "groovy" ] || [ "${TARGET}" == "focal" ]; then
#    dsc="OCAML_CAIRO2_${TARGET}_BASE"
#    DSCS="${!dsc}.dsc"
#else
#    :
#fi

#if [ "${TARGET}" == "groovy" ] || [ "${TARGET}" == "focal" ]; then
#    DSCS="${CAMLP5_4_11_BASE}.dsc"
#else
#    DSCS="${CAMLP5_BASE}.dsc"
#fi

#DSCS="${OCAML_NUM_BASE}.dsc"

#if [ "${TARGET}" == "groovy" ] || [ "${TARGET}" == "focal" ]; then
#    NEW_SOURCE_EXTRA="-s ${TARGET}"
#    PKGS="camlp5 ocaml-cairo2"
#else
#    DSCS="${CAMLP5_BASE}.dsc"
#fi

#PKGS="gcc-defaults"
#PKGS="gcc-5"
#DSCS="${OCAML_BASE}.dsc"

#PKGS="ocamlbuild"
#DSCS="${BINUTILS_BASE}.dsc"

#DSCS="${OCAMLBUILD_BASE}.dsc"

#DSCS="${FINDLIB_BASE}.dsc"

#DSCS="${OCAML_DUNE_BASE}.dsc ${HEVEA_BASE}.dsc"

#if [ "${TARGET}" == "groovy" ]; then
#    DSCS="${OCAMLBUILD_groovy_BASE}.dsc ${HEVEA_groovy_BASE}.dsc"
#else
#    DSCS="${OCAMLBUILD_BASE}.dsc ${HEVEA_BASE}.dsc"
#fi

#if [ "${TARGET}" == "groovy" ]; then
#    NEW_SOURCE_EXTRA="-s ${TARGET}"
#    PKGS="ocamlbuild hevea"
#else
#    DSCS="${HEVEA_BASE}.dsc ${OCAMLBUILD_BASE}.dsc"
#fi

#DSCS="${FINDLIB_BASE}.dsc"

#DSCS="${OCAML_GRAPHICS_BASE}.dsc" # PKGS="ocaml-graphics"

#DSCS="${FINDLIB_BASE}.dsc ${OCAML_DUNE_BASE}.dsc ${HEVEA_BASE}.dsc ${OCAMLBUILD_BASE}.dsc"
DSCS="${OCAML_DUNE_BASE}.dsc"
#DSCS="${OCAML_CSEXP_BASE}.dsc"

#DEBIAN_DSCS="${OCAML_ZARITH_BASE}.dsc"
#DEBUILD_SA_DSCS="${OCAML_ZARITH_BASE}.dsc"

#PKGS="gmp"
#PKGS="ocaml-dune"

# DSCS="${FINDLIB_BASE}.dsc"
#DEBIAN_DSCS="${LABLGTK3_BASE}.dsc"
#DEBUILD_SA_DSCS="${LABLGTK3_BASE}.dsc"
#DSCS="${CAMLP_STREAMS_BASE}.dsc"

#PRECISE_PKGS="libiberty"
#PRECISE_PKGS="lz4"

#DSCS="${GCC_DEFAULTS_BASE}.dsc"

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
#DSCS="${LABLGTK3_BASE}.dsc"
#DSCS="" # "${LABLGTK3_BASE}.dsc"



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

if [ -z "$TARGET" ]; then
  TARGET=trusty # precise #
fi

PPA="coq-master-daily" # "many-coq-versions-ocaml-4-08" # "many-coq-versions-ocaml-4-11" # "coq-master-daily" #"coq-8.13-daily" #"coq-master-daily" #"coq-8.10-daily" #"coq-master-daily" # "test-coq-new-ocaml-temp1"
SUFFIX="~ppa19"
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
        elif [[ "${i}" == "gtkspell3"* ]] || [[ "${i}" == "gcc-defaults_"* ]] || [[ "${i}" == "binutils_"* ]]; then
            URL_BASE="http://archive.ubuntu.com/ubuntu/pool/main/${i:0:1}/${i%%_*}/"
        fi
        echo "${URL_BASE}${BASE}.dsc"
        if [[ "${i}" == "gtkspell3"* ]]; then
            echo "${URL_BASE}${BASE}.debian.tar.gz"
        elif [[ "${i}" == "gcc-defaults_"* ]]; then
            echo "${URL_BASE}${BASE}.tar.gz"
        elif [[ "${i}" == "binutils_"* ]]; then
            echo "${URL_BASE}${BASE}.diff.gz"
        else
            echo "${URL_BASE}${BASE}.debian.tar.xz"
        fi
        if [[ "${i}" == "ocaml_"* ]] || [[ "${i}" == "libzstd_"* ]]; then # || [[ "${i}" == "lablgtk3"* ]]; then
            echo "${URL_BASE}${BASE%-*}.orig.tar.xz"
        elif [[ "${i}" == "dune_"* ]] || [[ "${i}" == "ocaml-dune_"* ]] || [[ "${i}" == "ocaml-csexp_"* ]] || [[ "${i}" == "cmdliner_"* ]] || [[ "${i}" == "rpm_"* ]] || [[ "${i}" == "ocaml-graphics_"* ]]; then
            echo "${URL_BASE}${BASE%-*}.orig.tar.bz2"
        elif [[ "${i}" == "gcc-defaults_"* ]]; then
            :
        else
            echo "${URL_BASE}${BASE%-*}.orig.tar.gz"
        fi
    done
    for i in ${DEBIAN_DSCS}; do
        BASE="${i%.dsc}"
        URL_BASE="http://deb.debian.org/debian/pool/main/${i:0:1}/${i%%_*}/"
        echo "${URL_BASE}${BASE}.dsc"
        echo "${URL_BASE}${BASE}.debian.tar.xz"
        echo "${URL_BASE}${BASE%-*}.orig.tar.gz"
    done
}

function extra_debuild_args_for() {
    if [ ! -z "${DEBUILD_SA_DSCS}" ] && [[ "$i" == *"${DEBUILD_SA_DSCS}"* ]]; then
        echo "-sa"
    fi
    if [[ "$i" == *"${LABLGTK3_BASE}"* ]]; then
        echo "-nc"
    fi
}

URLS="$(make_urls)"

function to_folder_name() {
    FOLDER="$1"
    #FOLDER="${FOLDER%.debian.tar.xz}"
    BEFORE_UNDERSCORE="${FOLDER%%_*}"
    AFTER_UNDERSCORE="${FOLDER#*_}"
    AFTER_UNDERSCORE="${AFTER_UNDERSCORE%.dsc}"
    AFTER_UNDERSCORE="${AFTER_UNDERSCORE%-*}"
    FOLDER="${BEFORE_UNDERSCORE}-${AFTER_UNDERSCORE}"
    #FOLDER="${FOLDER//_/-}"
    echo "${FOLDER}"
}

function to_preversion() {
    VERSION="$1"
    VERSION="${VERSION%.dsc}"
    VERSION="${VERSION##*_}"
    echo "${VERSION}"
}

function get_ppa_ext() {
    AFTER_UNDERSCORE="${1#*_}"
    if [[ "${AFTER_UNDERSCORE}" == *"-"* ]]; then
        echo "${PPA_EXT}"
    else
        echo "-1${PPA_EXT}"
    fi
}

function to_version() {
    VERSION="$(to_preversion "$1")"
    echo "${VERSION}$(get_ppa_ext "$1")"
}

function to_changes() {
    CHANGES="$1"
    CHANGES="${CHANGES%.dsc}"
    CHANGES="${CHANGES}$(get_ppa_ext "$1")_source.changes"
    echo "${CHANGES}"
}
