#!/usr/bin/env bash

#
# shellrc.sh: sourced by .zshrc and .bashrc to finish setup
#
#  - Should contain aliases, expensive commands, and other non-essential configs
#

# @audit handled by python plugin
run:if-cmd python source:file "$XDG_CONFIG_HOME/dotfiles/configs/pythonrc.sh"
run:if-cmd fzf source:file "$XDG_CONFIG_HOME/dotfiles/configs/fzf-rc.sh"
run:if-cmd fzf source:file "$XDG_CONFIG_HOME/dotfiles/configs/forgit-rc.sh"

# @note Commented out because nvm is slow to start.
# @todo do they have a lazy loader?
# source:file "$NVM_DIR/nvm.sh" &&
#     export NVM_DIR="$HOME/.nvm" &&
#     source:file "$NVM_DIR/bash_completion"

# @note currently unused
# source:file "$HOME/.rvm/scripts/rvm"

# Load aliases last to overwrite any conflicting ones defined by plugins.
source:file "$XDG_CONFIG_HOME/dotfiles/configs/aliases.sh"
if [ -r "$XDG_CONFIG_HOME/dotfiles/configs/workrc.sh" ]; then
    source:file "$XDG_CONFIG_HOME/dotfiles/configs/workrc.sh"
fi

#
# Hooks
#

# node: fnm
# @audit
eval:if-cmd fnm fnm env --use-on-cd --log-level quiet

# rbenv
# @audit
eval:if-cmd rbenv rbenv init -
