#!/bin/bash

CUR_VERSION="$(grep -o 'ppa\([0-9]*\)' versions.sh | sed s'/^ppa//g')"
NEW_VERSION="$(($CUR_VERSION+1))"

set -ex

sed -i s"/ppa$CUR_VERSION/ppa$NEW_VERSION/g" versions.sh
