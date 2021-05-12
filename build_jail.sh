#!/usr/bin/env bash

NAME="$1"
dir="$(dirname "$0")"

link_bin () {
  CHROOT="/home/$NAME"
  mkdir -p $CHROOT$*
  cp $* $CHROOT$*

  for i in $( ldd $* | grep -v dynamic | cut -d " " -f 3 | sed 's/://' | sort | uniq )
    do
      cp -v --parents $i $CHROOT
    done
}

echo "Building chroot jail for user '$NAME'..."
mkdir -p /home/$NAME/dev
cd /home/$NAME/dev
mknod -m 666 null c 1 3
mknod -m 666 tty c 5 0
mknod -m 666 zero c 1 5
mknod -m 666 random c 1 8
chown root:root /home/$NAME
chmod 0775 /home/$NAME
mkdir /home/$NAME/bin

link_bin "/bin/ash"
link_bin "/bin/bash"
link_bin "/bin/ls"
link_bin "/bin/echo"
link_bin "/bin/cp"
link_bin "/bin/rm"
link_bin "/bin/mv"
link_bin "/bin/cat"
link_bin "/bin/mkdir"
link_bin "/bin/touch"
link_bin "/bin/pwd"
link_bin "/bin/grep"
link_bin "/bin/sed"
link_bin "/usr/bin/nvim"
link_bin "/usr/bin/ssh"
link_bin "/usr/bin/ssh-add"
link_bin "/usr/bin/ssh-keygen"

echo "Built chroot jail for user '$NAME'!"
