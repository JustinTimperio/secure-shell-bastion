#!/usr/bin/env bash

dir="$(dirname $(readlink -f $0))"
source "$dir/config.sh"
CHROOT="/home/$NAME"

path="$(dirname $(readlink -f $*))"
mkdir -p $CHROOT$path
cp -v $* $CHROOT$*

for i in $( ldd $* | grep -v dynamic | cut -d " " -f 3 | sed 's/://' | sort | uniq )
  do
    cp -v --parents $i $CHROOT
done
