#!/usr/bin/env sh

cat /etc/passwd | grep Linux | cut -d: -f1
