#!/usr/bin/env sh

export EDITOR=vi
export VISUAL=vi
export PAGER=less

#
# Path
#

export PATH=/opt/bin:"$PATH"
export XDG_CONFIG_HOME="$HOME/.config"

#
# Colors
#

# base16
# @audit do we need it if we have iterm2? seems not to work without iterm2
# anyway
# Base16 Shell: https://github.com/tinted-theming/base16-shell
# base16_shell="$HOME/.config/base16-shell"
# # shellcheck source=/dev/null
# if [ -n "$PS1" ] && [ -s "$base16_shell/profile_helper.sh" ]; then
#     . "$base16_shell/profile_helper.sh"
#     base_16_tomorrow_night_eighties
# fi

#
# fzf
#

if [ -x "$(command -v fd)" ]; then
    export FZF_DEFAULT_COMMAND='fd --type f --strip-cwd-prefix --exclude .git'
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
    export FZF_ALT_C_COMMAND="$FZF_DEFAULT_COMMAND"
else
    echo "[warn]: fd not found"
fi

export FZF_DEFAULT_OPTS="--layout=reverse --info=inline"

# Start fzf in a tmux split pane.
# export FZF_TMUX=1

# If there's only one result, select it. Exit if the list is empty.
export FZF_CTRL_T_OPTS="--select-1 --exit-0"
export FZF_ALT_C_OPTS="--select-1 --exit-0"

#
# bat
#

export BAT_THEME="base16"

#
# Python
#

export PYTHONSTARTUP="$HOME/.pystartup"

# pyenv
export PYENV_ROOT="$HOME/.pyenv"
#command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
#eval "$(pyenv init --path)"

# virtualenvwrapper
# @todo need to source/export so it knows about env vars?
# WORKON_HOME=$HOME/.virtualenvs
# PROJECT_HOME=$HOME/workspace
#/usr/local/bin/virtualenvwrapper.sh

#
# Node
# @todo commented out because it's slow
#

# nvm
export NVM_DIR="$HOME/.nvm"
# shellcheck source=/dev/null
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
# shellcheck source=/dev/null
[ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"

#
# Ruby
#

# rvm
# shellcheck source=/dev/null
[ -s "$HOME/.rvm/scripts/rvm" ] && . "$HOME/.rvm/scripts/rvm"
