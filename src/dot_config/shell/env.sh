#!/usr/bin/env sh

#
# env.sh: shared environment for all shells
#  - Sourced by ~/.bashrc and ~/.zshenv
#  - Should only contain env vars and path
#  - Should not produce output or assume the shell is attached to a tty
#

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

export LANG="${LANG:-'en_US.UTF-8'}"

# https://specifications.freedesktop.org/basedir-spec/latest/
# @todo replace all instances with these var, including ~/.config, etc
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"
export XDG_CACHE_HOME="$HOME/.cache"

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
export GOBIN="$GOPATH/bin"

#
# Path
#
# Set the list of directories where the shell searches for programs.
#

# Priority: low -> high
for dir in \
    /sbin \
    /bin \
    /usr/sbin \
    /usr/bin \
    /usr/local/bin \
    $HOME/.local/bin \
    /opt/homebrew/bin \
    $HOME/.cargo/bin \
    $GOPATH/bin; do
    if [ -d "$dir" ]; then
        PATH="$dir:$PATH"
    fi
done
export PATH
