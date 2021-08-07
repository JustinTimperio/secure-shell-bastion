#!/usr/bin/env sh

# Startup
DIR="$(dirname $(readlink -f $0))"
USER_NAME="$1"
echo "Building chroot jail for user '$USER_NAME'..."

###################################
# Make Dev
###################################

mkdir -p /home/$USER_NAME/dev
mkdir /home/$USER_NAME/bin
cd /home/$USER_NAME/dev
mknod -m 666 null c 1 3
mknod -m 666 tty c 5 0
mknod -m 666 zero c 1 5
mknod -m 666 random c 1 8


###################################
# Link Each Bin to Chroot
###################################

"$DIR"/bin/link_bin.sh /bin/ash "$USER_NAME"
"$DIR"/bin/link_bin.sh /bin/ls "$USER_NAME"
"$DIR"/bin/link_bin.sh /bin/echo "$USER_NAME"
"$DIR"/bin/link_bin.sh /bin/cp "$USER_NAME"
"$DIR"/bin/link_bin.sh /bin/rm "$USER_NAME"
"$DIR"/bin/link_bin.sh /bin/mv "$USER_NAME"
"$DIR"/bin/link_bin.sh /bin/cat "$USER_NAME"
"$DIR"/bin/link_bin.sh /bin/mkdir "$USER_NAME"
"$DIR"/bin/link_bin.sh /usr/bin/clear "$USER_NAME"
"$DIR"/bin/link_bin.sh /bin/touch "$USER_NAME"
"$DIR"/bin/link_bin.sh /bin/grep "$USER_NAME"
"$DIR"/bin/link_bin.sh /bin/sed "$USER_NAME"
"$DIR"/bin/link_bin.sh /usr/bin/vi "$USER_NAME"
"$DIR"/bin/link_bin.sh /usr/bin/nano "$USER_NAME"
"$DIR"/bin/link_bin.sh /usr/bin/ssh "$USER_NAME"
"$DIR"/bin/link_bin.sh /usr/bin/ssh-agent "$USER_NAME"
"$DIR"/bin/link_bin.sh /usr/bin/ssh-keyscan "$USER_NAME"
"$DIR"/bin/link_bin.sh /usr/bin/ssh-keygen "$USER_NAME"
"$DIR"/bin/link_bin.sh /usr/bin/ssh-add "$USER_NAME"

###################################
# Stage New Jailed User 
###################################

adduser $USER_NAME -D
addgroup $USER_NAME $USER_NAME
sed -i s/$USER_NAME:!/"$USER_NAME:*"/g /etc/shadow
mkdir /home/$USER_NAME/etc
cp -v /etc/passwd /home/$USER_NAME/etc/passwd
cp -v /etc/group /home/$USER_NAME/etc/group

# Clean traces of users from fakeroot enviro
for USER in $(/opt/secure-shell-bastion/bin/list_users.sh); do
      if [ "$USER" != "$USER_NAME" ]; then
              sed -i "/$USER/d" /home/$USER_NAME/etc/passwd
      fi
done

for USER in $(/opt/secure-shell-bastion/bin/list_users.sh); do
      if [ $USER != $USER_NAME ]; then
              sed -i "/$USER/d" /home/$USER_NAME/etc/group
      fi
done

###################################
# Generate User Keys
###################################

mkdir -p /home/$USER_NAME/home/$USER_NAME/.ssh
ssh-keygen -b 4096 -f /home/$USER_NAME/home/$USER_NAME/.ssh/id_rsa -C "$USER_NAME"@bastion -N ''
touch /home/$USER_NAME/home/$USER_NAME/.ssh/authorized_keys
vi /home/$USER_NAME/home/$USER_NAME/.ssh/authorized_keys


###################################
# Set Final Perms
###################################
chown root:root /home/$USER_NAME
chown -R $USER_NAME:$USER_NAME /home/$USER_NAME/home/$USER_NAME

chmod 755 /home/$USER_NAME
chmod -R 755 /home/$USER_NAME/bin
chmod -R 755 /home/$USER_NAME/lib
chmod 700 /home/$USER_NAME/home/$USER_NAME
chmod 700 /home/$USER_NAME/home/$USER_NAME/.ssh
chmod 600 /home/$USER_NAME/home/$USER_NAME/.ssh/id_rsa
chmod 644 /home/$USER_NAME/home/$USER_NAME/.ssh/id_rsa.pub
chmod 755 /home/$USER_NAME/home/$USER_NAME/.ssh/authorized_keys

###################################
# Update SSHD Config
###################################
echo "Match User $USER_NAME" >> /etc/ssh/sshd_config
echo "  ChrootDirectory /home/$USER_NAME" >> /etc/ssh/sshd_config
echo "  AuthorizedKeysFile /home/$USER_NAME/home/$USER_NAME/.ssh/authorized_keys" >> /etc/ssh/sshd_config
/etc/init.d/sshd restart

echo ''
echo "Built chroot jail for user $USER_NAME!"
echo ''

