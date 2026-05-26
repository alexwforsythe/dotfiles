#!/usr/bin/env bash

#
# profile.sh: executed by bash and zsh in all interactive shells
#
#  - Contains initial environment setup for bash and zsh
#    - bash: sourced by ~/.bash_profile (login) and ~/.bashrc (non-login)
#    - zsh: sourced by ~/.zshrc (all)
#  - Should not run any external commands or expensive operations because the
#    prompt and other plugins aren't set up yet
#

# Load shared helpers.
_rchelpers="$XDG_CONFIG_HOME/shell/helpers.sh"
# shellcheck source=src/dot_config/shell/helpers.sh
if [ ! -r "$_rchelpers" ] || ! source "$_rchelpers"; then
  printf '[error] %s\n' "file not loaded: $_rchelpers" >&2
  return 1
fi
log:debug "file loaded: $_rchelpers"
unset _rchelpers

#
# Terminal
#

if [[ $OSTYPE == darwin* ]]; then
  export IS_MACOS=true
  [ -z "$BROWSER" ] && export BROWSER=open
fi

if [ -n "$TMUX" ] || [ "${TERM%%[-.]*}" = "tmux" ]; then
  export IS_TMUX=true
  export TERM="xterm-256color-italic"
fi

#
# Theme
#

# tinty: https://github.com/tinted-theming/tinted-shell?tab=readme-ov-file#customization
export TINTED_SHELL_ENABLE_BASE16_VARS=1
export TINTED_SHELL_ENABLE_BASE24_VARS=1
export TINTY_DIR="$XDG_DATA_HOME/tinted-theming/tinty"

# Load shell color theme early (before prompt plugins) so colors look good for
# the rest of setup.
#
# https://github.com/tinted-theming/tinted-shell/blob/main/USAGE.md#oh-my-zsh
source:file "$TINTY_DIR/tinted-shell-scripts-file.sh"

#
# Environment: path/command-dependent
#

# Use bat for manpages: https://github.com/sharkdp/bat?tab=readme-ov-file#man
run:if-cmd bat export MANPAGER="sh -c 'sed -u -e \"s/\\x1B\[[0-9;]*m//g; s/.\\x08//g\" | bat -p -lman'"
