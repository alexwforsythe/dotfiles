#!/usr/bin/env bash

#
# shellrc
#
# A shared RC file for bash and zsh containing aliases, functions, and other
# things that shouldn't go in .profile. Should be sourced by .bashrc and .zshrc.
#
# @todo merge with .profile (need before & after files tho, bc of plugins?)
#

#
# Environment variables
#

# @todo move into config dir, do we need a tmuxrc?
export TMUX_PLUGIN_MANAGER_PATH=$HOME/.tmux/plugins

#
# Other RC files
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
source:file "$XDG_CONFIG_HOME/dotfiles/configs/workrc.sh"
