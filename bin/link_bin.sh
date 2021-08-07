#!/usr/bin/env bash

USER_NAME="$2"
CHROOT="/home/$USER_NAME"
BIN_DIR="$(dirname $(readlink -f $1))"

mkdir -p $CHROOT$BIN_DIR
cp -v $1 $CHROOT$1

for LIB in $( ldd $1 | grep -v dynamic | cut -d " " -f 3 | sed 's/://' | sort | uniq )
  do
    cp -v --parents $LIB $CHROOT
done
