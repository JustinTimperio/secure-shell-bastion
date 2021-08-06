#!/usr/bin/env sh

USER_NAME="$1"
cat /home/"$USER_NAME"/.ssh/authorized_keys
