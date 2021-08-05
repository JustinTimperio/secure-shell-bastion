#!/usr/bin/env sh

INSTALL_PATH="/opt/secure-shell-bastion"

echo "Removing Secure-Shell-Bastion...."

sudo rm -rf $INSTALL_PATH
sudo rm -f /usr/bin/ssb

echo "Remove Secure-Shell-Bastion!"
