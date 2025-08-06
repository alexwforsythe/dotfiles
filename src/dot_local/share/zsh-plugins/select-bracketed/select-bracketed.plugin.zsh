#!/usr/bin/env zsh
# shellcheck shell=bash

#
# select-bracketed: text object for matching characters between matching pairs
# of brackets
#
#  - For example: given (( i+1 )), the vi command ci( will change all the text
#    between matching colons
#
# https://github.com/zsh-users/zsh/blob/master/Functions/Zle/select-bracketed
#

autoload -Uz select-bracketed
zle -N select-bracketed
for m in visual viopp; do
  # shellcheck disable=2296
  for c in {a,i}${(s..)^:-'()[]{}<>bB'}; do
    bindkey -M $m $c select-bracketed
  done
done
