#!/usr/bin/env sh
USER_NAME="$1"

echo ''
echo "Building chroot jail for user '$USER_NAME'..."
echo ''

###################################
# Finds all shared libs for a bin
###################################

link_bin () {
  CHROOT="/home/$USER_NAME"
  mkdir -p $CHROOT$*
  cp $* $CHROOT$*

  for i in $( ldd $* | grep -v dynamic | cut -d " " -f 3 | sed 's/://' | sort | uniq )
    do
      cp -v --parents $i $CHROOT
    done
}


###################################
# Stage New Jailed User 
###################################

adduser $USER_NAME -D
mkdir -p /home/$USER_NAME/dev
cd /home/$USER_NAME/dev

mknod -m 666 null c 1 3
mknod -m 666 tty c 5 0
mknod -m 666 zero c 1 5
mknod -m 666 random c 1 8

chown root:root /home/$USER_NAME
chmod 0775 /home/$USER_NAME
mkdir /home/$USER_NAME/bin


###################################
# Link Each Bin to Chroot
###################################

# Core
link_bin "/bin/ash"
link_bin "/bin/bash"
link_bin "/bin/ls"
link_bin "/bin/cp"
link_bin "/bin/rm"
link_bin "/bin/mv"
link_bin "/bin/cat"
link_bin "/bin/pwd"
link_bin "/bin/echo"
link_bin "/bin/date"
link_bin "/bin/mkdir"
link_bin "/bin/touch"

# SSH
link_bin "/usr/bin/ssh"
link_bin "/usr/bin/ssh-add"
link_bin "/usr/bin/ssh-keygen"

# Applications
link_bin "/bin/sed"
link_bin "/bin/grep"
link_bin "/usr/bin/vi"
link_bin "/usr/bin/nano"

echo ''
echo "Built chroot jail for user $USER_NAME!"
echo ''
