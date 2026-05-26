#!/usr/bin/env zsh
# shellcheck shell=bash

#
# fzf.zsh: configures fzf and then loads its fuzzy completion functions and
# keybindings.
#  - https://thevaluable.dev/fzf-shell-integration
#
#  https://github.com/junegunn/fzf
#

if [ -z "$FZF_DIR" ] || ! iscmd fzf; then
    return
fi

source:file $XDG_CONFIG_HOME/shell/fzf.sh
source:file $FZF_DIR/shell/completion.zsh
source:file $FZF_DIR/shell/key-bindings.zsh
