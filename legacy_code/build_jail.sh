#!/usr/bin/env bash

# Startup
dir="$(dirname $(readlink -f $0))"
source "$dir/config.sh"
echo "Building chroot jail for user '$NAME'..."

# Build Fakeroot
mkdir -p /home/$NAME/dev
cd /home/$NAME/dev
mknod -m 666 null c 1 3
mknod -m 666 tty c 5 0
mknod -m 666 zero c 1 5
mknod -m 666 random c 1 8
mkdir /home/$NAME/bin

# Link Binaries
"$dir"/link_bin.sh /bin/ash
"$dir"/link_bin.sh /bin/ls
"$dir"/link_bin.sh /bin/echo
"$dir"/link_bin.sh /bin/cp
"$dir"/link_bin.sh /bin/rm
"$dir"/link_bin.sh /bin/mv
"$dir"/link_bin.sh /bin/cat
"$dir"/link_bin.sh /bin/mkdir
"$dir"/link_bin.sh /usr/bin/clear
"$dir"/link_bin.sh /bin/touch
"$dir"/link_bin.sh /bin/grep
"$dir"/link_bin.sh /bin/sed
"$dir"/link_bin.sh /usr/bin/vi
"$dir"/link_bin.sh /usr/bin/nano
"$dir"/link_bin.sh /usr/bin/ssh
"$dir"/link_bin.sh /usr/bin/ssh-agent
"$dir"/link_bin.sh /usr/bin/ssh-keyscan
"$dir"/link_bin.sh /usr/bin/ssh-keygen
"$dir"/link_bin.sh /usr/bin/ssh-add
"$dir"/link_bin.sh /usr/bin/xterm

# Create Linux User
adduser $NAME -D
addgroup $NAME
sed -i s/$NAME:!/"$NAME:*"/g /etc/shadow
mkdir /home/$NAME/etc
mkdir -p /home/$NAME/home/$NAME/.ssh
cp -v /etc/passwd /home/$NAME/etc/passwd
cp -v /etc/group /home/$NAME/etc/group

# Gen Keys
#mkdir -p /home/$NAME/home/$NAME/.ssh
ssh-keygen -b 4096 -f /home/$NAME/home/$NAME/.ssh/id_rsa -N ''
sed -i s/alpine/bastion/g /home/$NAME/home/$NAME/.ssh/id_rsa.pub
sed -i s/root/$NAME/g /home/$NAME/home/$NAME/.ssh/id_rsa.pub
vi /home/$NAME/home/$NAME/.ssh/authorized_keys

# Set Final Perms
chmod 700 /home/$NAME/home/$NAME
chmod 700 /home/$NAME/home/$NAME/.ssh
chown -R $NAME:$NAME /home/$NAME/home/$NAME
chown root:root /home/$NAME
chmod 755 /home/$NAME

# Update SSHD Config
echo "Match User $NAME" >> /etc/ssh/sshd_config
echo "  ChrootDirectory /home/$NAME" >> /etc/ssh/sshd_config
echo "  AuthorizedKeysFile /home/$NAME/home/$NAME/.ssh/authorized_keys" >> /etc/ssh/sshd_config
/etc/init.d/sshd restart
echo "Built chroot jail for user '$NAME'!"

