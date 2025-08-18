#!/usr/bin/env zsh
# shellcheck shell=bash

#
# Settings
#

# @todo if completions dump is expired (20h, prezto completion module), reload
# in background:
# # Recompile the completion dump in the background to increase startup speed.
# _comp_path="${XDG_CACHE_HOME:-$HOME/.cache}/prezto/zcompdump"
# autoload -Uz zrecompile
# zrecompile -p -M "$_comp_path"

# Only show completions for exact matches.
unsetopt completeinword
# Complete globs instead of inserting them. The expansion will be shown in the
# zsh-autocomplete menu anyway.
setopt globcomplete

# Override the match (ma) color to be more subtle--fg white, bg gray, bold--to
# match our fzf theme.
# @todo update based on new fzf theme
zstyle ':completion:*' list-colors "ma=38;5;251;48;5;237;1"

# ignore completion to functions starting with _
zstyle ':completion:*:functions' ignored-patterns '_*'
# menu selection with a cursor will be used when the number of possible matches doesn't fit the screen
zstyle ':completion:*' menu select=long
# menu selection with a cursor will be used for git commands
zstyle ':completion:*:git*:*' menu select=2

# @audit auto-select first item?
setopt menucomplete

#
# Formats
#

zstyle ':completion:*' list-separator 

_tagfmt () {
  # @note We use normal printf escape sequences to avoid the "do you wish to see
  # all possibilities" prompt:
  # https://github.com/marlonrichert/zsh-autocomplete/issues/654
  zstyle ":completion:*${1:+:$1}" \
    format $(pprint ${3:-8} bold "${2:-󰌕} ${5:-%d}${${4:+ $4}:-}")
    # format "%F{${3:-8}%B${2:-󰌕} ${5:-%d}${${4:+ $4}:-}%b%f"
}

# default
# Set the default completion format.
_tagfmt
# Override the default -command- format set by zsh-autocomplete.
_tagfmt '-command-:*'
_tagfmt heads  # 󱉟
_tagfmt aliases  #   
_tagfmt all-expansions 
_tagfmt all-files 
_tagfmt argument-rest 
_tagfmt arguments 󰫧 #  󰫧 󰺲
_tagfmt arrays 󰅪
_tagfmt association-keys 
_tagfmt builtins 󱆃
_tagfmt colors  # 
_tagfmt commands  #  󰏓
_tagfmt corrections  green '(errors: %e)' # 󰅏  
_tagfmt descriptions 
_tagfmt directories 
_tagfmt directory-stack  # 
_tagfmt domains 󰇗 #   󰇖
_tagfmt events 
_tagfmt expansions 󰑑 # 
_tagfmt files 
_tagfmt fonts  # 
_tagfmt functions 󰊕
_tagfmt globbed-files  # 󰙅  
_tagfmt groups 
_tagfmt history-words 
_tagfmt history-lines  # 󰯓 󰯂
_tagfmt hosts 
_tagfmt jobs  #  
_tagfmt keymaps  # 󰌓 󰌌
_tagfmt libraries  # 󱉟
_tagfmt 'ls:*:argument-rest' 
_tagfmt 'manuals.*'  #  
_tagfmt messages 󰍢 purple #  
_tagfmt modules  #  
_tagfmt named-directories 󰲂
_tagfmt names 󰌕
_tagfmt options 
_tagfmt original 󰒊
_tagfmt parameters  # 󰫧 󱃗
_tagfmt path-dirs 󱞊 # 󰴉
_tagfmt ports 󱇢 # 󱂇
_tagfmt processes 
_tagfmt processes-names 
_tagfmt recent-dirs  # 󰪺 󰉓
_tagfmt reserved-words 
_tagfmt signals  # 
_tagfmt strings  # 
_tagfmt styles  # zstyles
_tagfmt suffixes  # 󰨿 󰈤 file extensions
_tagfmt suffix-aliases 󰌧 #   󰘧
_tagfmt targets  # makefile targets
_tagfmt users 
_tagfmt values  # 
_tagfmt warnings  red '' 'no matches found'
_tagfmt widgets 󰜬 # 
_tagfmt zsh-options  #   󱕂

# git
# @todo set group-order zstyle for specific commands
_tagfmt blob-objects 
_tagfmt blob-tags 
_tagfmt blobs-and-trees-in-treeish  # 
_tagfmt blobs 
_tagfmt branch-names 
_tagfmt cached-files  # 
_tagfmt changed-in-index-files  # 
_tagfmt changed-in-working-tree-files  # 
_tagfmt commit-objects 
_tagfmt commit-ranges 
_tagfmt commit-tags 
_tagfmt commits  # 
_tagfmt heads-local  # 
_tagfmt heads-remote  # 
_tagfmt heads 
_tagfmt local-repositories 
_tagfmt modified-files 
_tagfmt other-files 
_tagfmt recent-branches 
_tagfmt references  # 
_tagfmt remote-branch-names-noprefix 
_tagfmt remote-repositories  #  
_tagfmt remotes 
_tagfmt revisions 
_tagfmt stashes 
_tagfmt submodules 
_tagfmt tree-ish-to-index-files 
_tagfmt tree-ishs  # 
_tagfmt untracked-files  # 

# docker ( containers,  images)
# @todo
