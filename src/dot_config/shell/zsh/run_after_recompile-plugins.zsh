#!/usr/bin/env zsh
# shellcheck shell=bash

emulate -LR zsh

autoload -U zrecompile

# Recompile zsh completions. -p is required to create/add new function digests.
# -M enables memory-mapping so multiple zsh processes can share the same dump in
# memory.
zrecompile -q -p -M "$ZSH_COMPDUMP"
