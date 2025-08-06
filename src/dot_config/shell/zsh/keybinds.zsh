#!/usr/bin/env zsh
# shellcheck shell=bash

#
# keybinds.zsh: contains user key bindings for zsh
#
# @todo
#  - history substring search
#   - up/down line
#   - accept
#   - accept and enter
#

# Remove mode switching delay for vicmd and viins.
export KEYTIMEOUT=1

# Extend (don't override) the built-in hooks to set the cursor mode.
# https://zsh.sourceforge.io/Doc/Release/User-Contributions.html
autoload -Uz set-cursor-mode add-zle-hook-widget
add-zle-hook-widget zle-line-init set-cursor-mode
add-zle-hook-widget zle-keymap-select set-cursor-mode

# Natural text editing
# @todo can we copy some from iterm2's key mappings?
# bindkey "\e[1;3C" forward-word
# bindkey "\e[1;3D" backward-word
# bindkey "\e[[3~" forward-delete-char # @todo delete word, add forward delete

#
# Expand aliases when pressing ctrl+space.
#
# https://github.com/rothgar/mastering-zsh/blob/master/docs/helpers/aliases.md#automatically-expand-aliases
#

# Expand aliases.
setopt aliases

# control-space expands all aliases, including global
autoload -Uz glob-alias
# bindkey -M viins "^ " glob-alias
# @audit more general expansion:
bindkey -M viins "^ " expand-word

# space to make a normal space
bindkey -M viins " " magic-space

# normal space during searches
bindkey -M isearch " " magic-space

# History substring search
# @todo trigger history menu or fzf?
# bindkey -M viins "$key_info[Control]K" history-substring-search-up
# bindkey -M viins "$key_info[Control]J" history-substring-search-down
bindkey -M viins "^k" up-line-or-search
bindkey -M viins "^j" down-line-or-search

# @todo history-incremental-search doesn't trigger with ^r (with fzf
# disabled)

#
# Add vim key bindings for completion menus.
#
# Note: must be loaded after compinit (i.e. prezto/init.zsh)
#
# https://thevaluable.dev/zsh-install-configure-mouseless/
#

# Load complist for access to the menuselect keymap.
zmodload -i zsh/complist
# Toggle interactive mode
# bindkey -M menuselect '^F' vi-insert
# @todo can we just globally map these to arrow keys?
bindkey -M menuselect '^h' backward-char
# bindkey -M menuselect '^j' down-line-or-history
bindkey -M viins '^j' down-line-or-search
bindkey -M menuselect '^j' down-line-or-search
# bindkey -M menuselect '^k' up-line-or-history
bindkey -M viins '^k' up-line-or-search
bindkey -M menuselect '^k' up-line-or-search
bindkey -M menuselect '^l' forward-char

bindkey -M viins '^n' menu-complete
bindkey -M viins '^p' reverse-menu-complete

# tmux-which-key: open tmux launcher when space is pressed in vicmd mode (like
# VSpaceCode)
#
# @todo move this to tmux-launcher.plugin.zsh and add zstyle option to configure
# key
if [ -n "$IS_TMUX" ]; then
    tmux-which-key() { tmux show-wk-menu-root; }
    zle -N tmux-which-key
    bindkey -M vicmd " " tmux-which-key
fi
