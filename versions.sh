#!/bin/bash

export GITHUB_PLUS_TO_MINUS_VERSIONS=""
export GITHUB_MINUS_TO_PLUS_VERSIONS="8.19+alpha 8.18+rc1 8.18+alpha 8.17+rc1 8.17+alpha 8.16+rc1 8.16+alpha 8.15+rc1 8.15+alpha 8.14+rc1 8.14+alpha 8.13+beta1 8.13+alpha 8.12+beta1 8.11+beta1 8.10+beta3 8.10+beta2 8.10+beta1 8.9+beta1 8.8+beta1 8.7+beta2 8.7+beta1"
export GITHUB_VERSIONS="8.18.0 8.17.1 8.17.0 8.16.1 8.16.0 8.15.2 8.15.1 8.15.0 8.14.1 8.14.0 8.13.2 8.13.1 8.13.0 8.12.2 8.12.1 8.12.0 8.11.2 8.11.1 8.11.0 8.10.2 8.10.1 8.10.0 8.9.1 8.9.0 8.8.2 8.8.1 8.8.0 8.7.2 8.7.1 8.7.0"

export NORMAL_VERSIONS="8.6.1 8.6 8.6rc1 8.6beta1 8.5pl3 8.5pl2 8.5pl1 8.5 8.5rc1 8.5beta3 8.5beta2 8.5beta1 8.4pl6 8.4pl5 8.4pl4 8.4pl3 8.4pl2 8.4pl1 8.4 8.4rc1 8.4beta2 8.4beta 8.3pl5 8.3pl4 8.3pl3 8.3pl2 8.3pl1 8.3 8.3-rc1 8.2pl3 8.2pl2 8.2pl1 8.2beta2 8.2alpha 8.1pl6 8.1pl4 8.1pl3 8.1pl2 8.1pl1 8.1 8.0pl3 7.4 7.3 7.3.1 7.2 7.1 7.0 6.3 6.3.1 6.2 6.2.4 6.2.3 6.2.2 6.2.1"

export VERSIONS="8.18.0" # "8.19+alpha 8.18.0 8.18+rc1 8.18+alpha 8.17.1 8.17.0 8.17+rc1 8.17+alpha 8.16.1 8.16.0 8.16+rc1 8.16+alpha 8.15.2 8.15.1 8.15.0 8.15+rc1 8.15+alpha 8.14.1 8.14.0 8.14+rc1 8.14+alpha 8.13.2 8.13.1 8.13.0 8.13+beta1 8.13+alpha 8.12.2 8.12.1 8.12.0 8.12+beta1 8.11.2 8.11.1 8.11.0 8.11+beta1 8.10.2 8.10.1 8.10.0 8.10+beta3 8.10+beta2 8.10+beta1 8.9.1 8.9.0 8.9+beta1 8.8.2 8.8.1 8.8.0 8.8+beta1 8.7.2 8.7.1 8.7.0 8.7+beta2 8.7+beta1 8.6.1 8.6 8.6rc1 8.6beta1 8.5pl3 8.5pl2 8.5pl1 8.5 8.5rc1 8.5beta3 8.5beta2 8.5beta1 8.4pl6 8.4pl5 8.4pl4 8.4pl3 8.4pl2 8.4pl1 8.4 8.4rc1 8.4beta2 8.4beta 8.3pl5 8.3pl4 8.3pl3 8.3pl2 8.3pl1 8.3 8.3-rc1 8.3-beta0 8.2pl3 8.2pl2 8.2pl1 8.2 8.2beta2 8.2alpha 8.1pl6 8.1pl5 8.1pl4 8.1pl3 8.1pl2 8.1pl1 8.1 8.0pl3 7.4 7.3 7.3.1 7.2 7.1 7.0 6.3 6.3.1 6.2 6.2.4 6.2.3 6.2.2 6.2.1 6.1 5.8.3 5.8.2 5.6"

if [ -z "$TARGET" ]; then
  TARGET=trusty # precise #
fi

if [ -z "${NEW_PPA}" ]; then
    NEW_PPA="many-coq-versions-ocaml-4-11"
fi

if [ -z "${VER_LT_8_16_PPA}" ]; then
    VER_LT_8_16_PPA="many-coq-versions-ocaml-4-08"
    #VER_LT_8_16_PPA="many-coq-versions-ocaml-4-11"
fi

if [ -z "${VER_LT_8_14_PPA}" ]; then
    VER_LT_8_14_PPA="many-coq-versions-ocaml-4-08"
    #VER_LT_8_14_PPA="many-coq-versions-ocaml-4-11"
fi

if [ -z "${VER_LT_8_11_1_PPA}" ]; then
    #VER_LT_8_11_1_PPA="many-coq-versions-ocaml-4-05"
    VER_LT_8_11_1_PPA="many-coq-versions-ocaml-4-08"
fi

PPA_COMMON="-1~${TARGET}~"
PPA_EXT="${PPA_COMMON}ppa206"

function ppa_wget_ext_of_version() {
    # don't let bump-versions
    PREFIX="${PPA_COMMON}ppa"
    if false; then :
    elif [[ "$1" == 8.12.1 ]]; then echo "${PREFIX}134"
    elif [[ "$1" == 8.12.0 ]]; then echo "${PREFIX}133"
    elif [[ "$1" == "8.12+beta"* ]]; then echo "${PREFIX}129"
    elif [[ "$1" == 8.11.2 ]]; then echo "${PREFIX}129"
    elif [[ "$1" == 8.11.1 ]]; then echo "${PREFIX}124"
    elif [[ "$1" == 8.11.0 ]]; then echo "${PREFIX}122"
    elif [[ "$1" == "8.11+beta"* ]]; then echo "${PREFIX}129"
    elif [[ "$1" == 8.10.2 ]]; then echo "${PREFIX}110"
    elif [[ "$1" == 8.10.1 ]]; then echo "${PREFIX}109"
    elif [[ "$1" == 8.10.0 ]]; then echo "${PREFIX}107"
    elif [[ "$1" == "8.10+beta"* ]]; then echo "${PREFIX}107"
    elif [[ "$1" == 8.9.1 ]]; then echo "${PREFIX}103"
    elif [[ "$1" == 8.9.0 ]]; then echo "${PREFIX}101"
    elif [[ "$1" == "8.9+beta"* ]]; then echo "${PREFIX}100"
    elif [[ "$1" == 8.8.2 ]]; then echo "${PREFIX}98"
    elif [[ "$1" == 8.8.1 ]]; then echo "${PREFIX}96"
    elif [[ "$1" == 8.8.0 ]]; then echo "${PREFIX}95"
    elif [[ "$1" == "8.8+beta"* ]]; then echo "${PREFIX}95"
    elif [[ "$1" == 8.7.2 ]]; then echo "${PREFIX}85"
    elif [[ "$1" == 8.7.1 ]]; then echo "${PREFIX}83"
    elif [[ "$1" == 8.7.0 ]]; then echo "${PREFIX}83"
    elif [[ "$1" == "8.7+beta"* ]]; then echo "${PREFIX}135"
    elif [[ "$1" == "8.6beta"* ]]; then echo "${PREFIX}48"
    elif [[ "$1" == "8.6rc"* ]]; then echo "${PREFIX}52"
    elif [[ "$1" == "8.6"* ]]; then echo "${PREFIX}83"
    elif [[ "$1" == "8.5"* ]]; then echo "${PREFIX}63"
    else
        echo "${PPA_EXT}"
    fi
}

function to_debian_version() {
  echo "$1" | sed s'/-\(rc\)/\1/g' | sed s'/+\(beta\)/\1/g' | sed s'/-\(beta\)/\1/g' | sed s'/-\(alpha\)/\1/g' | sed s'/+\(alpha\)/\1/g' | sed s'/\(rc\)/~\1/g' | sed s'/\(beta\)/~\1/g' | sed s'/\(alpha\)/~\1/g'
}


function increment_version() {
    # https://stackoverflow.com/questions/8653126/how-to-increment-version-number-in-a-shell-script#comment65908962_8653732
    echo "$1" | awk -F. -v OFS=. 'NF==1{print ++$NF}; NF>1{$NF=sprintf("%0*d", length($NF), ($NF+1)); print}'
}

function vercmp() {
    CMP="$2"
    if [[ "$CMP" == "<"  ]]; then CMP="lt"; fi
    if [[ "$CMP" == "<=" ]]; then CMP="le"; fi
    if [[ "$CMP" == ">"  ]]; then CMP="gt"; fi
    if [[ "$CMP" == ">=" ]]; then CMP="ge"; fi
    if [[ "$CMP" == "="  ]]; then CMP="eq"; fi
    if [[ "$CMP" == "==" ]]; then CMP="eq"; fi
    V1="$(to_debian_version "$1")"
    V2="$(to_debian_version "$3")"
    if [[ "$CMP" == "eq" && "$V2" == *"*" ]]; then
        V2="${V2::-1}" # strip the trailing star
        V3="$(increment_version "$V2")"
        (dpkg --compare-versions "${V2}~" "le" "$V1" && dpkg --compare-versions "$V1" "lt" "${V3}") || return $?
    else
        dpkg --compare-versions "$V1" "$CMP" "$V2" || return $?
    fi
}

function ppa_of_version_target() {
    # ppa_of_version_target $VERSION $TARGET
    if vercmp "$1" "<" "8.5~"; then
        echo "many-coq-versions-ocaml-3"
    elif vercmp "$i" "<" "8.10~"; then
        echo "many-coq-versions"
    elif vercmp "$i" "<" "8.11.1~"; then
        echo "${VER_LT_8_11_1_PPA}"
    elif vercmp "$i" "<" "8.14~"; then
        echo "${VER_LT_8_14_PPA}"
    elif vercmp "$i" "<" "8.16~"; then
        echo "${VER_LT_8_16_PPA}"
    else
        echo "${NEW_PPA}"
    fi
}

function to_package_name() {
  if [ ! -z "$2" ]; then
    echo "${1/coq/coq-$2}"
  else
    echo "coq-$1"
  fi
}

function to_folder_name() {
  PKG="$(to_debian_version "$1")"
  COQ="$(to_package_name "$1")"
  echo "${COQ}-${PKG}"
}

function to_archive_name() {
  PKG="$(to_debian_version "$1")"
  COQ="$(to_package_name "$1")"
  echo "${COQ}_${PKG}"
}
