#!/usr/bin/env sh

ALL_USERS=$(cat /etc/passwd | grep Linux | cut -d: -f1)
for USER in $ALL_USERS; do 
	if grep -q "$USER" /etc/ssh/sshd_config; then
    		echo "$USER"
	fi
done
