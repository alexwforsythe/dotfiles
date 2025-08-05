#!/usr/bin/env zsh

#
# zsh-autocomplete
#
# https://github.com/marlonrichert/zsh-autocomplete/blob/main/.zshrc
#
# @todo
#  - history menu above prompt?
#  - "do you want to display x items?"
#    - always no so it doesn't steal input
#    - or just pipe into fzf
#  - use ctrl+h/j/k/l to navigate menus, and opt+h/j/k/l to navigate panes
#  - decide on a completion hotkey (ctrl+. or something)
#

zstyle ':autocomplete:*' min-delay 0.3 # seconds (float)
# Wait this many seconds for typing to stop, before showing completions.

zstyle ':autocomplete:*' min-input 2 # characters (int)
# Wait until this many characters have been typed, before showing completions.

# This setting cannot be changed at runtime.
zstyle ':autocomplete:*' fzf-completion yes
# no:  Tab uses Zsh's completion system only.
# yes: Tab first tries Fzf's completion, then falls back to Zsh's.

# Add a space after these completions:
zstyle ':autocomplete:*' add-space \
    executables aliases functions builtins reserved-words commands

#
# Configs in this section should come AFTER sourcing zsh-autocomplete.
#

# Up arrow:
# @audit wtf are these in-strings?
# bindkey '\e[A' up-line-or-search
# bindkey '\eOA' up-line-or-search
bindkey "$key_info[Up]" up-line-or-search
bindkey -M vicmd 'k' up-line-or-search
# up-line-or-search:  Open history menu.
# up-line-or-history: Cycle to previous history line.

# Down arrow:
# bindkey '\e[B' down-line-or-select
# bindkey '\eOB' down-line-or-select
bindkey "$key_info[Down]" down-line-or-select
bindkey -M vicmd 'j' down-line-or-history
# down-line-or-select:  Open history menu.
# down-line-or-history: Cycle to next history line.

# @todo should we replace it with fzf? should we also make tab open fzf if it's
# more items than can be displayed in a menu?
# Control-Space:
# bindkey '\0' list-expand
bindkey '^_' list-expand
# list-expand:      Reveal hidden completions.
# set-mark-command: Activate text selection.

# Uncomment the following lines to disable live history search:
# @todo don't we want this if fzf is inactive?
zle -A {.,}history-incremental-search-forward
zle -A {.,}history-incremental-search-backward

# Return key in completion menu & history menu:
bindkey -M menuselect '\r' accept-line
# .accept-line: Accept command line.
# accept-line:  Accept selection and exit menu.

# @todo bindkey escape to close menu!
