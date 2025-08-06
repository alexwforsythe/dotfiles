#!/usr/bin/env zsh
# shellcheck shell=bash

#
# Formats
#
# 󰅩 󰅪  󰅴 󰅲
#

_tagfmt () {
  # shellcheck disable=2299
  echo "%F{${2:-8}%B${1:-󰌕} ${4:-%d}${${3:+ $3}:-}%b%f"
}

# Remove conflicting settings from zsh-autocomplete.
zstyle -d ':completion:*:-command-:*' group-name
zstyle -d ':completion:*:-command-:*' format
# zstyle -d ':completion:*:-command-:*' file-patterns
# zstyle -d ':completion:*:-command-:*' tag-order
# zstyle -d ':completion:*:all-expansions' group-name

# default
zstyle ':completion:*:heads' format "$(_tagfmt )" # 󱉟
zstyle ':completion:*:aliases' format "$(_tagfmt )" #   
zstyle ':completion:*:all-expansions' format "$(_tagfmt )"
zstyle ':completion:*:all-files' format "$(_tagfmt )"
zstyle ':completion:*:argument-rest' format "$(_tagfmt )"
zstyle ':completion:*:arguments' format "$(_tagfmt 󰫧)" #  󰫧 󰺲
zstyle ':completion:*:arrays' format "$(_tagfmt 󰅪)"
zstyle ':completion:*:association-keys' format "$(_tagfmt )"
zstyle ':completion:*:builtins' format "$(_tagfmt 󱆃)"
zstyle ':completion:*:colors' format "$(_tagfmt )" # 
zstyle ':completion:*:commands' format "$(_tagfmt )" #  󰏓
zstyle ':completion:*:corrections' format "$(_tagfmt  green '(errors: %e)')" # 󰅏  
zstyle ':completion:*:descriptions' format "$(_tagfmt )"
zstyle ':completion:*:directories' format "$(_tagfmt )"
zstyle ':completion:*:directory-stack' format "$(_tagfmt )" # 
zstyle ':completion:*:domains' format "$(_tagfmt 󰇗)" #   󰇖
zstyle ':completion:*:events' format "$(_tagfmt )"
zstyle ':completion:*:expansions' format "$(_tagfmt 󰑑)" # 
zstyle ':completion:*:files' format "$(_tagfmt )"
zstyle ':completion:*:fonts' format "$(_tagfmt )" # 
zstyle ':completion:*:functions' format "$(_tagfmt 󰊕)"
zstyle ':completion:*:globbed-files' format "$(_tagfmt )" # 󰙅  
zstyle ':completion:*:groups' format "$(_tagfmt )"
zstyle ':completion:*:history-words' format "$(_tagfmt )"
zstyle ':completion:*:history-lines' format "$(_tagfmt )" # 󰯓 󰯂
zstyle ':completion:*:hosts' format "$(_tagfmt )"
zstyle ':completion:*:jobs' format "$(_tagfmt )" #  
zstyle ':completion:*:keymaps' format "$(_tagfmt )" # 󰌓 󰌌
zstyle ':completion:*:libraries' format "$(_tagfmt )" # 󱉟
zstyle ':completion:*:ls:*:argument-rest' format "$(_tagfmt )"
zstyle ':completion:*:manuals.*' format "$(_tagfmt )" #  
zstyle ':completion:*:messages' format "$(_tagfmt 󰍢 purple)" #  
zstyle ':completion:*:modules' format "$(_tagfmt )" #  
zstyle ':completion:*:named-directories' format "$(_tagfmt 󰲂)"
zstyle ':completion:*:names' format "$(_tagfmt 󰌕)"
zstyle ':completion:*:options' format "$(_tagfmt )"
zstyle ':completion:*:original' format "$(_tagfmt 󰒊)"
zstyle ':completion:*:parameters' format "$(_tagfmt )" # 󰫧 󱃗
zstyle ':completion:*:path-dirs' format "$(_tagfmt 󱞊)" # 󰴉
zstyle ':completion:*:ports' format "$(_tagfmt 󱇢)" # 󱂇
zstyle ':completion:*:processes' format "$(_tagfmt )"
zstyle ':completion:*:processes-names' format "$(_tagfmt )"
zstyle ':completion:*:recent-dirs' format "$(_tagfmt )" # 󰪺 󰉓
zstyle ':completion:*:reserved-words' format "$(_tagfmt )"
zstyle ':completion:*:signals' format "$(_tagfmt )" # 
zstyle ':completion:*:strings' format "$(_tagfmt )" # 
zstyle ':completion:*:styles' format "$(_tagfmt )" # zstyles
zstyle ':completion:*:suffixes' format "$(_tagfmt )" # 󰨿 󰈤 file extensions
zstyle ':completion:*:suffix-aliases' format "$(_tagfmt 󰌧)" #   󰘧
zstyle ':completion:*:targets' format "$(_tagfmt )" # makefile targets
zstyle ':completion:*:users' format "$(_tagfmt )"
zstyle ':completion:*:values' format "$(_tagfmt )" # 
zstyle ':completion:*:warnings' format "$(_tagfmt  red '' 'no matches found')"
zstyle ':completion:*:widgets' format "$(_tagfmt 󰜬)" # 
zstyle ':completion:*:zsh-options' format "$(_tagfmt )" #   󱕂
zstyle ':completion:*' format "$(_tagfmt)"

# git
zstyle ':completion:*:blob-objects' format "$(_tagfmt )"
zstyle ':completion:*:blob-tags' format "$(_tagfmt )"
zstyle ':completion:*:blobs-and-trees-in-treeish' format "$(_tagfmt )" # 
zstyle ':completion:*:blobs' format "$(_tagfmt )"
zstyle ':completion:*:branch-names' format "$(_tagfmt )"
zstyle ':completion:*:cached-files' format "$(_tagfmt )" # 
zstyle ':completion:*:changed-in-index-files' format "$(_tagfmt )" # 
zstyle ':completion:*:changed-in-working-tree-files' format "$(_tagfmt )"
zstyle ':completion:*:commit-objects' format "$(_tagfmt )"
zstyle ':completion:*:commit-ranges' format "$(_tagfmt )"
zstyle ':completion:*:commit-tags' format "$(_tagfmt )"
zstyle ':completion:*:commits' format "$(_tagfmt )" # 
zstyle ':completion:*:heads-local' format "$(_tagfmt )" # 
zstyle ':completion:*:heads-remote' format "$(_tagfmt )" # 
zstyle ':completion:*:heads' format "$(_tagfmt )"
zstyle ':completion:*:local-repositories' format "$(_tagfmt )"
zstyle ':completion:*:modified-files' format "$(_tagfmt )"
zstyle ':completion:*:other-files' format "$(_tagfmt )"
zstyle ':completion:*:recent-branches' format "$(_tagfmt )"
zstyle ':completion:*:references' format "$(_tagfmt )" # 
zstyle ':completion:*:remote-branch-names-noprefix' format "$(_tagfmt )"
zstyle ':completion:*:remote-repositories' format "$(_tagfmt )" #  
zstyle ':completion:*:remotes' format "$(_tagfmt )"
zstyle ':completion:*:revisions' format "$(_tagfmt )"
zstyle ':completion:*:stashes' format "$(_tagfmt )"
zstyle ':completion:*:submodules' format "$(_tagfmt )"
zstyle ':completion:*:tree-ish-to-index-files' format "$(_tagfmt )"
zstyle ':completion:*:tree-ishs' format "$(_tagfmt )" # 
zstyle ':completion:*:untracked-files' format "$(_tagfmt )" # 

# docker ( containers,  images)
# @todo
