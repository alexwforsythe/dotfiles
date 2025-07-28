#!/usr/bin/env bash

#
# ~/.bash_profile: executed by bash for interactive login shells
#
#  - Should not run any external commands or expensive operations because the
#    prompt and other plugins aren't set up yet
#
# https://www.gnu.org/software/bash/manual/bash.html#Bash-Startup-Files
#

DOTFILES_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/dotfiles"

# Load .bashrc so login shells behave the same as non-login shells (it isn't
# sourced automatically by login shells).
bashrc="$DOTFILES_DIR/configs/.bashrc"
# shellcheck disable=1090
if [ ! -r "$bashrc" ] || ! source "$bashrc"; then
    printf '[error] %s\n' "file not loaded: $bashrc" >&2
    # Fall back to the default path.
    source "$HOME/.bashrc"
    return 1
fi
unset bashrc
