#!/usr/bin/env zsh
# shellcheck shell=bash

emulate -LR zsh

#
# build.zsh: generates scripts to be sourced by ~/.zshrc and compiles zsh
# completions.
#
#  - This script runs automatically after each call to `chezmoi apply`, which
#    ensures that generated scripts stay up-to-date
#  - Generating script files makes them easier to debug and avoids the need to
#    `eval` command output, which can slow down shell startup
#

autoload -Uz \
    zrecompile \
    print-load-plugins \
    print-init-commands

gen_dir=$XDG_CONFIG_HOME/shell/zsh/gen
mkdir -p $gen_dir

# Generate load-plugins.zsh.
source "$XDG_CONFIG_HOME/shell/zsh/plugins.zsh"
print-load-plugins $plugins >$gen_dir/load-plugins.zsh
unset plugins

# Generate init-commands.zsh.
print-init-commands >$gen_dir/init-commands.zsh

# Recompile zsh completions.
#  - -p: required to create/add new functions to the digest
#  - -U: suppress alias expansion
#  - -M: enables memory-mapping so multiple zsh processes can share the digest
zrecompile -p -U -M "$ZSH_COMPDUMP"
