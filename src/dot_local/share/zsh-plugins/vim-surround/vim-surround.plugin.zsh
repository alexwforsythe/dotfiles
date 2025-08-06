#!/usr/bin/env zsh
# shellcheck shell=bash

#
# vim-surround
#
# https://thevaluable.dev/zsh-install-configure-mouseless/
#

autoload -Uz surround

zle -N add-surround surround
zle -N change-surround surround
zle -N delete-surround surround

bindkey -M vicmd ys add-surround
bindkey -M visual S add-surround
bindkey -M vicmd cs change-surround
bindkey -M vicmd ds delete-surround
