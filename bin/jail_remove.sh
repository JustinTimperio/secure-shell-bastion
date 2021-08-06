#!/usr/bin/env sh

USER_NAME="$1"
deluser "$USER_NAME" --remove-home
