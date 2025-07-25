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

is-macos() { [[ $OSTYPE == darwin* ]]; }

#
# Terminal
#

[[ -n "$LANG" ]] || export LANG='en_US.UTF-8'
[[ -n "$TMUX" ]] || export TERM="xterm-256color-italic"

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

is-macos && export BROWSER=open

#
# Config
#

export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$XDG_CONFIG_HOME/local/share"
export XDG_CACHE_HOME="$XDG_CONFIG_HOME/cache"

# Readline config:
# https://www.gnu.org/software/bash/manual/html_node/Readline-Init-File.html
export INPUTRC="$XDG_CONFIG_HOME/dotfiles/configs/.inputrc"

#
# Logging
#

export LOG_LEVEL_DEBUG=1
export LOG_LEVEL_INFO=2
export LOG_LEVEL_WARN=3
export LOG_LEVEL_ERROR=4

RC_LOG_LEVEL=${RC_LOG_LEVEL:-$LOG_LEVEL_DEBUG}
export RC_LOG_LEVEL

_red=$'\e[1;31m'
_grn=$'\e[1;32m'
_yel=$'\e[1;33m'
_blu=$'\e[1;34m'
_mag=$'\e[1;35m'
_cyn=$'\e[1;36m'
_end=$'\e[0m'

log:debug() { ((RC_LOG_LEVEL <= LOG_LEVEL_DEBUG)) && printf "[${_cyn}debug${_end}] %s\n" "$@"; }
log:info() { ((RC_LOG_LEVEL <= LOG_LEVEL_INFO)) && printf "[${_grn}info${_end}] %s\n" "$@"; }
log:warn() { ((RC_LOG_LEVEL <= LOG_LEVEL_WARN)) && printf "[${_yel}warn${_end}] %s\n" "$@"; }
log:error() { ((RC_LOG_LEVEL <= LOG_LEVEL_ERROR)) && printf "[${_red}error${_end}] %s\n" "$@"; }

#
# Helpers
#
# Only the most basic, common functions should be defined in .profile.
# Everything else should go in RC files.
#

# @todo rename to source-file and replace source:if-cmd with:
#
# if-cmd $1 source:file $2
source:file() {
  if [[ ! -r "$1" ]]; then
    log:debug "file not found: $1"
    return 1
  fi

  # shellcheck disable=SC1090
  if . "$1"; then
    log:debug "file loaded: $1"
    return 0
  else
    log:error "file not loaded: $1"
    return 1
  fi
}

run:if-cmd() {
  if ! command -v "$1" >/dev/null; then
    log:warn "command not found: $1"
    return 1
  fi

  "${@:2}"
}

run:if-not-cmd() {
  if ! command -v "$1" >/dev/null; then
    "${@:2}"
  fi
}

setup-fzf() {
  # Install fzf.
  run:if-not-cmd fzf run:if-cmd brew brew install fzf
  run:if-not-cmd fzf return 1

  # Install fzfrc.
  if [ ! -r "$1" ]; then
    log:info "Installing $1 - enter Y, Y, N ..."
    /opt/homebrew/opt/fzf/install
  fi

  # Load fzfrc.
  source:file "$1"
}

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
