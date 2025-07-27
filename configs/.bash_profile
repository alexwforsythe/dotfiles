#!/usr/bin/env bash

#
# .bash_profile: executed by bash(1) for interactive login shells
#
#  - Should not run any external commands or expensive operations because the
#    prompt and other plugins aren't set up yet
#
# https://www.gnu.org/software/bash/manual/bash.html#Bash-Startup-Files
#

profile="$DOTFILES_DIR/configs/profile.sh"

# Load shell profile to share environment variables, etc.
# shellcheck disable=1090
if [ ! -r "$profile" ] || ! source "$profile"; then
    printf '[error] %s\n' "file not loaded: $profile"
    return 1
fi

log:debug "file loaded: $profile"
unset profile

source:file "$DOTFILES_DIR/configs/.bashrc" \
    || source:file "$HOME/.bashrc"
