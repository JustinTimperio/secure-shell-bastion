#!/usr/bin/env sh

INSTALL_PATH="/opt/secure-shell-bastion"

echo "Installing Secure-Shell-Bastion...."

sudo rm -rf $INSTALL_PATH
sudo git clone https://github.com/JustinTimperio/secure-shell-bastion.git $INSTALL_PATH
sudo ln -sf $INSTALL_PATH/ssb.sh /usr/bin/ssb

echo "Installed Secure-Shell-Bastion!"
