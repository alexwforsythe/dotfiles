#!/usr/bin/env bash

#
# profile.sh: executed by sh for login shells
#
#  - Contains initial environment setup for bash and zsh
#    - bash: sourced by .bash_profile
#    - zsh: sourced by .zshrc
#  - Should not run any external commands or expensive operations because the
#    prompt and other plugins aren't set up yet
#

#
# Terminal
#

export LANG="${LANG:-'en_US.UTF-8'}"

if [[ $OSTYPE == darwin* ]]; then
  export IS_MACOS=true
  [ -z "$BROWSER" ] && export BROWSER=open
fi

if [ -n "$TMUX" ] || [ "${TERM%%[-.]*}" = "tmux" ]; then
  export IS_TMUX=true
  export TERM="xterm-256color-italic"
fi

#
# Default commands
#

export EDITOR=vim
export VISUAL=vim
export PAGER=less
export LESS="--hilite-search \
--hilite-unread \
--ignore-case \
--LONG-PROMPT \
--mouse \
--quiet \
--quit-if-one-screen \
--RAW-CONTROL-CHARS \
--window=-4 \
--use-color"

#
# Config
#

# https://specifications.freedesktop.org/basedir-spec/latest/
# @todo replace all instances with these var, including ~/.config, etc
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"
export XDG_CACHE_HOME="$HOME/.cache"

# Readline config:
# https://www.gnu.org/software/bash/manual/html_node/Readline-Init-File.html
# @todo maybe link to ~/.inputrc
export INPUTRC="$XDG_CONFIG_HOME/dotfiles/configs/.inputrc"


#
# Helpers
#

helpers="${XDG_CONFIG_HOME:-$HOME/.config}/dotfiles/configs/helpers.sh"
# shellcheck disable=1090
if [ ! -r "$helpers" ] || ! source "$helpers"; then
  printf '[error] %s\n' "file not loaded: $helpers"
  return 1
fi

log:debug "file loaded: $helpers"
unset helpers

#
# Shared setup
#

# Prepend gnubin to path to use gls and gdircolors instead of ls and dircolors.
# Unlike the macOS builtins, the GNU versions read and write to LS_COLORS
# instead of LSCOLORS. Most zsh plugins--including completion--use LS_COLORS, so
# this leads to more consistent output colorization.
#
# @todo use constant for homebrew opt path
if is-macos; then
  gnubin="/opt/homebrew/opt/coreutils/libexec/gnubin"
  if [ ! -d $gnubin ]; then
    run:if-cmd brew brew install coreutils
  fi

  if [ ! -d $gnubin ]; then
    log:warn "gnubin not found"
  else
    export PATH="$gnubin:$PATH"
  fi
fi
