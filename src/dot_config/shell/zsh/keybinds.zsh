#!/usr/bin/env zsh
# shellcheck shell=bash

#
# keybinds.zsh: contains user key bindings for zsh
#

#
# Editor
#

# Remove mode switching delay for vicmd and viins.
export KEYTIMEOUT=1

# Extend (don't override) the built-in hooks to set the cursor mode.
# https://zsh.sourceforge.io/Doc/Release/User-Contributions.html
autoload -Uz set-cursor-mode add-zle-hook-widget
add-zle-hook-widget zle-line-init set-cursor-mode
add-zle-hook-widget zle-keymap-select set-cursor-mode

# Alt left/right move between words (macOS). Key sequences aren't the same for
# all shells, so use cat to check them.
bindkey '^[b' vi-backward-word
bindkey '^[f' vi-forward-word

#
# Expansion
#
# https://github.com/rothgar/mastering-zsh/blob/master/docs/helpers/aliases.md#automatically-expand-aliases
#

# Expand aliases.
setopt aliases

# Space inserts a normal space.
bindkey ' ' magic-space

# Ctrl-space attempts shell expansion on the current word (like expand-word),
# including aliases and suffix aliases, and then inserts a space.
autoload -Uz glob-alias
bindkey -M viins '^ ' glob-alias

#
# History
#
# history-substring-search
#  - history-substring-search-up: cycle through previous matches
#  - history-substring-search-down: cycle through subsequent matches
#
# zsh-autocomplete
#  - up-line-or-search: up if in history menu, otherwise open history menu
#  - down-line-or-select: down if in history menu, otherwise menu-select
#  - up-line-or-history: cycle to previous history line (like normal zsh)
#  - down-line-or-history: cycle to next history line (like normal zsh)
#
# @todo
#  - [ ] don't insert ; after select items
#  - [ ] history menu doesn't open for ls
#

# history-substring-search
# @note replaced by fzf
# bindkey '^r' history-substring-search-up
# bindkey '^s' history-substring-search-down

# zsh-autocomplete history menu
bindkey "$key_info[Up]" up-line-or-search
bindkey "$key_info[Down]" down-line-or-select
bindkey '^k' up-line-or-search
bindkey '^j' down-line-or-select

#
# Completion
#
#  - .accept-line: always submit the command
#  - accept-line:
#    - in menu: accept completion and close the menu
#    - outside menu: submit the command
#  - send-break: clear inserted word and close the menu
#  - menu-select: enter the menu with a cursor and insert the selected item
#  - menu-complete:
#    - in menu: move the cursor to the next item (replacing inserted word)
#    - outside menu: cycle inserted word to the next completion (no cursor)
#  - reverse-menu-complete:
#    - in menu: move cursor to the previous item (replacing inserted word)
#    - outside menu: cycle inserted word to the previous completion (no cursor)
#
# Completion widgets:
# https://zsh.sourceforge.io/Doc/Release/Zsh-Line-Editor.html#Completion
#
# Special widget behavior in menu selection:
# https://zsh.sourceforge.io/Doc/Release/Zsh-Modules.html#Menu-selection
#
# @todo
#  - [ ] always use list menus (so j/k makes sense)
#  - [ ] maybe use same keybinds in fzf
#

# menu-select doesn't clear suggestions from zsh-autosuggestions when
# entering the completion menu, unless it's wrapped:
# https://github.com/zsh-users/zsh-autosuggestions/issues/816
menu-select-fixed() { zle menu-select; }
zle -N menu-select-fixed

# Tab/shift+tab, ctrl+n/p, and ctrl+j/k enter the interactive completion menu.
bindkey '^I' menu-select-fixed
bindkey "$key_info[BackTab]" menu-select-fixed
bindkey '^n' menu-select-fixed
bindkey '^p' menu-select-fixed
# @note handled by zsh-autocomplete history menu widgets (above)
# bindkey '^j' menu-select-fixed
# bindkey '^k' menu-select-fixed

# Escape rejects the completion and closes the menu.
bindkey -M menuselect "$key_info[Escape]" send-break
# Enter always submits the command (even in menus).
bindkey -M menuselect '\r' .accept-line
# Tab/shift+tab cycle the cursor in the completion menu, with tab attempting
# shell expansion on the current word first.
bindkey -M menuselect '^I' menu-expand-or-complete
bindkey -M menuselect "$key_info[BackTab]" reverse-menu-complete
# Ctrl+u/d move the cursor one screenful up/down.
bindkey -M menuselect '^d' forward-word
bindkey -M menuselect '^u' backward-word
# Ctrl+n/p cycles the cursor through groups in the completion menu.
bindkey -M menuselect '^n' vi-forward-blank-word
bindkey -M menuselect '^p' vi-backward-blank-word
# Ctrl+j/k cycle the cursor in the completion menu.
bindkey -M menuselect '^j' menu-complete
bindkey -M menuselect '^k' reverse-menu-complete
# Ctrl+l inserts the selected completion and, in case of directories, opens the
# menu to complete its children. Ctrl+h undoes the previous completion, creating
# a simple file browser with ctrl+l (accept-and-infer-next-history).
# https://zsh.sourceforge.io/Guide/zshguide06.html#l149
bindkey -M menuselect '^l' accept-and-infer-next-history
bindkey -M menuselect '^h' undo
# Ctrl+space inserts the selection and moves the cursor to the next item,
# keeping the menu open.
bindkey -M menuselect '^ ' accept-and-hold
# Ctrl+e accepts the selected completion by inserting the longest unambiguous
# string that matches.
bindkey -M menuselect '^e' insert-unambiguous-or-complete

# Directional navigation in completion menus (like arrow keys). Useful for
# non-list completion menus, especially when using column sort (default).
# @note using menu-complete instead (above)
# https://thevaluable.dev/zsh-install-configure-mouseless
# bindkey -M menuselect '^h' backward-char
# bindkey -M menuselect '^j' down-line-or-select
# bindkey -M menuselect '^k' up-line-or-search
# bindkey -M menuselect '^l' forward-char

#
# Custom widgets
#

# tmux-which-key: space opens tmux-which-key in vicmd mode (like VSpaceCode).
if [ -n "$IS_TMUX" ]; then
    tmux-which-key() { tmux show-wk-menu-root; }
    zle -N tmux-which-key
    bindkey -M vicmd ' ' tmux-which-key
fi
