#!/usr/bin/env zsh
# shellcheck shell=bash

init_commands_path=$XDG_CONFIG_HOME/shell/zsh/init-commands.zsh

autoload -Uz print-init-commands
print-init-commands >"$init_commands_path"

# Use this line instead to init the commands directly:
# source <(print-init-commands)
