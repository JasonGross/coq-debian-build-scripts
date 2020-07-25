#!/bin/bash

export GITHUB_PLUS_TO_MINUS_VERSIONS=""
export GITHUB_MINUS_TO_PLUS_VERSIONS="8.12+beta1 8.11+beta1 8.10+beta3 8.10+beta2 8.10+beta1 8.9+beta1 8.8+beta1 8.7+beta2 8.7+beta1"
export GITHUB_VERSIONS="8.12.0 8.11.2 8.11.1 8.11.0 8.10.2 8.10.1 8.10.0 8.9.1 8.9.0 8.8.2 8.8.1 8.8.0 8.7.2 8.7.1 8.7.0"

export NORMAL_VERSIONS="8.6.1 8.6 8.6rc1 8.6beta1 8.5pl3 8.5pl2 8.5pl1 8.5 8.5rc1 8.5beta3 8.5beta2 8.5beta1 8.4pl6 8.4pl5 8.4pl4 8.4pl3 8.4pl2 8.4pl1 8.4 8.4rc1 8.4beta2 8.4beta 8.3pl5 8.3pl4 8.3pl3 8.3pl2 8.3pl1 8.3 8.3-rc1 8.2pl3 8.2pl2 8.2pl1 8.2beta2 8.2alpha 8.1pl6 8.1pl4 8.1pl3 8.1pl2 8.1pl1 8.1 8.0pl3 7.4 7.3 7.3.1 7.2 7.1 7.0 6.3 6.3.1 6.2 6.2.4 6.2.3 6.2.2 6.2.1"

export VERSIONS="8.12.0" # "8.12.0 8.12+beta1 8.11.2 8.11.1 8.11.0 8.11+beta1 8.10.2 8.10.1 8.10.0 8.10+beta3 8.10+beta2 8.10+beta1 8.9.1 8.9.0 8.9+beta1 8.8.2 8.8.1 8.8.0 8.8+beta1 8.7.2 8.7.1 8.7.0 8.7+beta2 8.7+beta1 8.6.1 8.6 8.6rc1 8.6beta1 8.5pl3 8.5pl2 8.5pl1 8.5 8.5rc1 8.5beta3 8.5beta2 8.5beta1 8.4pl6 8.4pl5 8.4pl4 8.4pl3 8.4pl2 8.4pl1 8.4 8.4rc1 8.4beta2 8.4beta 8.3pl5 8.3pl4 8.3pl3 8.3pl2 8.3pl1 8.3 8.3-rc1 8.3-beta0 8.2pl3 8.2pl2 8.2pl1 8.2 8.2beta2 8.2alpha 8.1pl6 8.1pl5 8.1pl4 8.1pl3 8.1pl2 8.1pl1 8.1 8.0pl3 7.4 7.3 7.3.1 7.2 7.1 7.0 6.3 6.3.1 6.2 6.2.4 6.2.3 6.2.2 6.2.1 6.1 5.8.3 5.8.2 5.6"

if [ -z "$TARGET" ]; then
  TARGET=trusty # precise #
fi

PPA_EXT="-1~${TARGET}~ppa134"

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
