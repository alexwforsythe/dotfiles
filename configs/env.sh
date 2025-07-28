#!/usr/bin/env sh

#
# env.sh: shared environment for all shells
#
#  - Login, non-login
#  - Sourced by .bash_profile and .zshenv
#  - Should only contain env vars and path
#  - Should not product output or assume the shell is attached to a tty
#

# https://specifications.freedesktop.org/basedir-spec/latest/
# @todo replace all instances with these var, including ~/.config, etc
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"
export XDG_CACHE_HOME="$HOME/.cache"

export ZDOTDIR="$HOME"

export DOTFILES_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/dotfiles"
