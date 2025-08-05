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
export VISUAL=$EDITOR
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

# Readline config:
# https://www.gnu.org/software/bash/manual/html_node/Readline-Init-File.html
# @todo maybe link to ~/.inputrc
export INPUTRC="$HOME/.inputrc"

#
# Environment
#

# js
export YARN_CACHE_FOLDER="$XDG_CACHE_HOME/yarn/v6"
export BUN_INSTALL_CACHE_DIR="$XDG_CACHE_HOME/bun/install/cache"

# gcloud
export GOOGLE_APPLICATION_CREDENTIALS="$XDG_CONFIG_HOME/gcloud/application_default_credentials.json"

# go
export GOPATH="$HOME/go"

# tmux
# This should be where tmux plugins are installed, not tpm itself.
export TMUX_PLUGIN_MANAGER_PATH="$XDG_DATA_HOME/tmux-plugins"

# tinty: https://github.com/tinted-theming/tinted-shell?tab=readme-ov-file#customization
export TINTED_SHELL_ENABLE_BASE16_VARS=1
export TINTED_SHELL_ENABLE_BASE24_VARS=1
export TINTY_DIR="$XDG_DATA_HOME/tinted-theming/tinty"

#
# Theme
#

# Load shell color theme early (before prompt plugins) so colors look good for
# the rest of setup.
#
# https://github.com/tinted-theming/tinted-shell/blob/main/USAGE.md#oh-my-zsh
source:file "$TINTY_DIR/tinted-shell-scripts-file.sh"

#
# Path
#
# Set the list of directories where the shell searches for programs.
#

path-append \
  /usr/local/bin \
  /usr/local/sbin \
  /usr/bin \
  /usr/sbin \
  /bin \
  /sbin

if [ -n "$IS_MACOS" ] && [ -z "$HOMEBREW_PREFIX" ]; then
  # Set homebrew prefix and add bins to path.
  if [ -d /opt/homebrew/bin ]; then
    path-prepend /opt/homebrew/bin
    eval:if-cmd brew brew shellenv
  else
    log:warn "homebrew not found in /opt/homebrew/bin"
  fi
fi

# java: override system installation. This is needed for the PlantUML VSCode
# extension.
if [ -n "$HOMEBREW_PREFIX" ]; then
  path-prepend \
    "$HOMEBREW_PREFIX/opt/mysql@8.0/bin" \
    "$HOMEBREW_PREFIX/opt/openjdk/bin"

  # @todo link brew completions if not linked
fi

path-prepend \
  "$HOME/.local/bin" \
  "$HOME/.local/sbin" \
  "$HOME/.cargo/bin" \
  "$GOPATH/bin"

#
# Environment: path/command-dependent
#

# Use bat for manpages: https://github.com/sharkdp/bat?tab=readme-ov-file#man
run:if-cmd bat export MANPAGER="sh -c 'sed -u -e \"s/\\x1B\[[0-9;]*m//g; s/.\\x08//g\" | bat -p -lman'"
