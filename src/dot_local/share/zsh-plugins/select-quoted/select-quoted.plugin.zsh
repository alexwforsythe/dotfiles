#!/usr/bin/env zsh
# shellcheck shell=bash

#
# select-quoted: text object for matching characters between a particular
# delimiter
#
#  - For example: given "text", the vi command vi" will select all the text
#    between the double quotes
#
# https://github.com/zsh-users/zsh/blob/master/Functions/Zle/select-quoted
#

autoload -Uz select-quoted
zle -N select-quoted
for m in visual viopp; do
    for c in {a,i}{\',\",\`}; do
        bindkey -M $m $c select-quoted
    done
done
