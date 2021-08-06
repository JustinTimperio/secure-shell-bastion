#!/usr/bin/env sh

USER_NAME="$1"
deluser --remove-home "$USER_NAME"

sed -i "/Match User $USER_NAME/d" /etc/ssh/sshd_config
sed -i "/  ChrootDirectory \/home\/$USER_NAME/d" /etc/ssh/sshd_config
sed -i "/  AuthorizedKeysFile \/home\/$USER_NAME\/home\/$USER_NAME\/.ssh\/authorized_keys/d" /etc/ssh/sshd_config
