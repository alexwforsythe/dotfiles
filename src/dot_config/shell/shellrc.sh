#!/usr/bin/env bash

#
# shellrc.sh: sourced by .zshrc and .bashrc to finish setup
#
#  - Should contain aliases, expensive commands, and other non-essential configs
#

# @audit handled by python plugin
run:if-cmd python3 source:file "$XDG_CONFIG_HOME/shell/pythonrc.sh"
if iscmd fzf; then
    export FZF_DIR="$HOMEBREW_PREFIX/opt/fzf"
    path-append "$FZF_DIR/bin"
    source:file "$XDG_CONFIG_HOME/shell/fzf-rc.sh"
    # @audit removed plugin -- still want to use it?
    # source:file "$XDG_CONFIG_HOME/shell/forgit-rc.sh"
fi

# Load aliases last to overwrite any conflicting ones defined by plugins.
source:file "$XDG_CONFIG_HOME/shell/aliases.sh"
if [ -r "$XDG_CONFIG_HOME/shell/workrc.sh" ]; then
    source:file "$XDG_CONFIG_HOME/shell/workrc.sh"
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

# tinty
TINTY_SCHEME=${TINTY_SCHEME:-$(<"$TINTY_DIR/current_scheme")}
export TINTY_SCHEME

# @audit looks lighter than tinted-shell
# @todo migrate to iterm2rc and call from tinty config hook
# iTerm2: https://github.com/tinted-theming/tinted-terminal?tab=readme-ov-file#tinty-4
# if [ "$TERM_PROGRAM" = "iTerm.app" ]; then
#     tinty_theme="$TINTY_DIR/tinted-terminal-themes-16-iterm2-applescripts-file.scpt"
#     iterm2_autolaunch="$HOME/Library/Application Support/iTerm2/Scripts/AutoLaunch.scpt"
#     run:if-file "$tinty_theme" cp -f "$tinty_theme" "$iterm2_autolaunch"
#     osascript "$iterm2_autolaunch"
#     unset tinty_theme
#     unset iterm2_autolaunch
# fi
