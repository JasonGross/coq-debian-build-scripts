#!/bin/bash

set -ex

mkdir -p coq-source
cd coq-source

for i in pl1; do #"" beta1 beta2 beta3 rc1; do
  wget -N https://coq.inria.fr/distrib/V8.5$i/files/coq-8.5$i.tar.gz
done
function comment() {
for i in pl6 pl5 pl4 pl3 pl2 pl1 "" rc1 beta2 beta; do
  wget -N https://coq.inria.fr/distrib/V8.4$i/files/coq-8.4$i.tar.gz || exit $?
done
for i in trunk v8.5 v8.4 v8.3 v8.2 v8.1 v8.0; do
  if [ ! -d coq-$i ]; then
    git clone https://github.com/coq/coq.git --branch=$i coq-$i
  else
    (cd coq-$i && git remote update && git checkout $i && git pull origin $i:$i -f)
  fi
done
for i in pl5 pl4 pl3 pl2 pl1 "" "-rc1"; do
  wget -N https://coq.inria.fr/distrib/V8.3$i/files/coq-8.3$i.tar.gz || exit $?
done
for i in "-beta0"; do
  wget -N https://coq.inria.fr/distrib/V8.3$i/files/coq-8.3$i-1.tar.gz || exit $?
  cp -af coq-8.3$i-1.tar.gz coq-8.3$i.tar.gz
done
for i in pl3 pl2 pl1 beta2 alpha; do # rc1 beta4 beta3 beta have no files, beta1 has confusingly named files
  wget -N https://coq.inria.fr/distrib/V8.2$i/files/coq-8.2$i.tar.gz || exit $?
done
for i in ""; do
  wget -N https://coq.inria.fr/distrib/V8.2$i/files/coq-8.2$i-1.tar.gz || exit $?
  cp -af coq-8.2$i-1.tar.gz coq-8.2$i.tar.gz
done
for i in pl6 pl4 pl3 pl2 pl1 ""; do # gamma beta have no files
  wget -N https://coq.inria.fr/distrib/V8.1$i/files/coq-8.1$i.tar.gz || exit $?
done
for i in pl5; do
  wget -N https://coq.inria.fr/distrib/V8.1$i/files/coq-8.1$i-1.tar.gz || exit $?
  cp -af coq-8.1$i-1.tar.gz coq-8.1$i.tar.gz
done
for i in pl3; do # pl4 "" have no files
  wget -N https://coq.inria.fr/distrib/V8.0$i/coq-8.0$i.tar.gz || exit $?
done
for i in 7.4 7.3 7.3.1 7.2 7.1 7.0 6.3 6.3.1 6.2 6.2.4 6.2.3 6.2.2 6.2.1; do # 5.8.3 5.8.2 5.6; do # 5.10 has no files, 6.2.beta is named strangely
  wget -N https://coq.inria.fr/distrib/V$i/coq-$i.tar.gz || exit $?
done
for i in 6.1; do
  # wget -N https://coq.inria.fr/distrib/V$i/V$i.tar.z || exit $? # actually .tar.gz
  wget -N https://coq.inria.fr/distrib/V$i/V$i-ocaml1.07.tar.gz || exit $?
  cp -af V$i-ocaml1.07.tar.gz coq-$i.tar.gz
done
for i in 5.8.3 5.8.2 5.6; do
  mkdir -p $i
  pushd $i
  rm -rf coq-$i
  mkdir coq-$i
  wget -N https://coq.inria.fr/distrib/V$i/coq.tar.Z || exit $?
  cp -af coq.tar.Z coq-$i/
  if [ "$i" == 5.8.3 -o "$i" == 5.8.2 ]; then
    if [ "$i" == 5.8.3 ]; then MAX=10; fi
    if [ "$i" == 5.8.2 ]; then MAX=8; fi
    for j in $(seq -f %02g 1 $MAX); do
      wget -N https://coq.inria.fr/distrib/V$i/coq.$j || exit $?
      cp -af coq.$j coq-$i/
    done
  fi
  cd coq-$i/
  uncompress coq.tar.Z
  tar xf coq.tar
  ls coq.*
  rm coq.*
  cd ..
  rm -f coq-$i.tar.gz
  tar -czvf coq-$i.tar.gz coq-$i
  cp -af coq-$i.tar.gz ../
  popd
done
}
