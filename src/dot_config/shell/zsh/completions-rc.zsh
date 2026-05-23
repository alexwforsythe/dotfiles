#!/usr/bin/env zsh
# shellcheck shell=bash

#
# completions-rc.zsh: settings for the zsh completion system
#
#  - Mostly copied from prezto/completion
#    - Can't source it because it calls compinit, which we've delegated to
#      zsh-autocomplete to avoid compatibility issues
#    - Options and zstyles that conflict with zsh-autocomplete have been
#      removed, especially anything related to menus
#  - Should be loaded after zsh-autocomplete and other completion plugins so our
#    settings take precedence
#

# --- start modified prezto ---

#
# Options
#

# Trigger completions even when the cursor is not at the end of a word (e.g.
# when editing a previous word on the command line). @audit
# setopt completeinword
# Move cursor to the end of a completed word.
setopt alwaystoend
# Perform path search even on command names with slashes.
setopt pathdirs
# Show completion menu on a successive tab press.
# setopt automenu
# Automatically list choices on ambiguous completion.
# setopt autolist
# If completed parameter is a directory, add a trailing slash.
setopt autoparamslash
# Needed for file modification glob modifiers with compinit.
setopt extendedglob
# Do not autoselect the first completion entry.
# unsetopt menucomplete
# Disable start/stop characters in shell editor.
unsetopt flowcontrol

#
# Variables
#

# Standard style used by default for 'list-colors'
LS_COLORS=${LS_COLORS:-'di=34:ln=35:so=32:pi=33:ex=31:bd=36;01:cd=33;01:su=31;40;07:sg=36;40;07:tw=32;40;07:ow=33;40;07:'}
# Override the match (ma) color to be more subtle--fg lighter white, bg darkest
# gray, bold--to match our fzf theme.
_ls_color_match='ma=1;38;5;21;48;5;18'

#
# Styles
#

# Defaults.
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS} $_ls_color_match
zstyle ':completion:*:default' list-prompt '%S%M matches%s'

# Use caching to make completion for commands such as dpkg and apt usable.
zstyle ':completion::complete:*' use-cache on
zstyle ':completion::complete:*' cache-path $ZSH_COMPCACHE

# Group matches and describe.
zstyle ':completion:*:matches' group 'yes'
zstyle ':completion:*:options' description 'yes'
zstyle ':completion:*:options' auto-description '%d'
zstyle ':completion:*' verbose yes

# Fuzzy match mistyped completions.
# zstyle ':completion:*' completer _complete _match _approximate
zstyle ':completion:*:match:*' original only
zstyle ':completion:*:approximate:*' max-errors 1 numeric

# Increase the number of errors based on the length of the typed word. But make
# sure to cap (at 7) the max-errors to avoid hanging.
#
# This is the default zsh-autocomplete setting modified to include prezto's
# logic for an upper limit:
autocomplete:config:max-errors() {
  typeset -ga reply=($((max(7, min( 2, ($#PREFIX + $#SUFFIX) / 3)))))
}

# Don't complete unavailable commands. (prezto + zsh-autocomplete)
zstyle ':completion:*:functions' ignored-patterns '_*' 'pre(cmd|exec)' '*.*' '*:*' '+*'

# Array completion element sorting.
zstyle ':completion:*:*:-subscript-:*' tag-order indexes parameters

# Directories
# zstyle ':completion:*:*:cd:*' tag-order local-directories directory-stack path-directories
# zstyle ':completion:*:-tilde-:*' group-order 'named-directories' 'path-directories' 'users' 'expand'
zstyle ':completion:*' squeeze-slashes true

# History
zstyle ':completion:*:history-words' stop yes
zstyle ':completion:*:history-words' remove-all-dups yes

# Environment Variables
zstyle ':completion::*:(-command-|export):*' fake-parameters ${${${_comps[(I)-value-*]#*,}%%,*}:#-*-}

# Populate hostname completion. But allow ignoring custom entries from static
# */etc/hosts* which might be uninteresting.
# @audit is this set up correctly?
zstyle ':completion:*:hosts' etc-host-ignores '_etc_host_ignores'

zstyle -e ':completion:*:hosts' hosts 'reply=(
  ${=${=${=${${(f)"$(cat {/etc/ssh/ssh_,~/.ssh/}known_hosts(|2)(N) 2> /dev/null)"}%%[#| ]*}//\]:[0-9]*/ }//,/ }//\[/ }
  ${=${(f)"$(cat /etc/hosts(|)(N) <<(ypcat hosts 2> /dev/null))"}%%(\#${_etc_host_ignores:+|${(j:|:)~_etc_host_ignores}})*}
  ${=${${${${(@M)${(f)"$(cat ~/.ssh/config 2> /dev/null)"}:#Host *}#Host }:#*\**}:#*\?*}}
)'

# Ignore multiple entries.
zstyle ':completion:*:(rm|kill|diff):*' ignore-line other
zstyle ':completion:*:rm:*' file-patterns '*:all-files'

# Kill
zstyle ':completion:*:*:*:*:processes' command 'ps -u $LOGNAME -o pid,user,command -w'
zstyle ':completion:*:*:kill:*:processes' list-colors "=(#b) #([0-9]#) ([0-9a-z-]#)*=01;36=0=01" $_ls_color_match
zstyle ':completion:*:*:kill:*' insert-ids single

# Man
zstyle ':completion:*:manuals' separate-sections true
zstyle ':completion:*:manuals.(^1*)' insert-sections true

# Media Players
zstyle ':completion:*:*:mpg123:*' file-patterns '*.(mp3|MP3):mp3\ files *(-/):directories'
zstyle ':completion:*:*:mpg321:*' file-patterns '*.(mp3|MP3):mp3\ files *(-/):directories'
zstyle ':completion:*:*:ogg123:*' file-patterns '*.(ogg|OGG|flac):ogg\ files *(-/):directories'
zstyle ':completion:*:*:mocp:*' file-patterns '*.(wav|WAV|mp3|MP3|ogg|OGG|flac):ogg\ files *(-/):directories'

# ssh/scp/rsync
zstyle ':completion:*:(ssh|scp|rsync):*' tag-order 'hosts:-host:host hosts:-domain:domain hosts:-ipaddr:ip\ address *'
zstyle ':completion:*:(scp|rsync):*' group-order users files all-files hosts-domain hosts-host hosts-ipaddr
zstyle ':completion:*:ssh:*' group-order users hosts-domain hosts-host users hosts-ipaddr
zstyle ':completion:*:(ssh|scp|rsync):*:hosts-host' ignored-patterns '*(.|:)*' loopback ip6-loopback localhost ip6-localhost broadcasthost
zstyle ':completion:*:(ssh|scp|rsync):*:hosts-domain' ignored-patterns '<->.<->.<->.<->' '^[-[:alnum:]]##(.[-[:alnum:]]##)##' '*@*'
zstyle ':completion:*:(ssh|scp|rsync):*:hosts-ipaddr' ignored-patterns '^(<->.<->.<->.<->|(|::)([[:xdigit:].]##:(#c,2))##(|%*))' '127.0.0.<->' '255.255.255.255' '::1' 'fe80::*'

# --- end modified prezto ---

#
# Settings
#

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

# Point _git to git-completion.bash so it doesn't have to search for it every
# time the function loads. This is only used by the official git zsh completions
# (git-completion.zsh), not the one that ships with zsh.
zstyle ':completion:*:*:git:*' script $XDG_DATA_HOME/bash-plugins/external-completions/git-completion.bash

#
# Formats
#

zstyle ':completion:*' list-separator 

_tagfmt() {
  # @note We use normal printf escape sequences to avoid the "do you wish to see
  # all possibilities" prompt:
  # https://github.com/marlonrichert/zsh-autocomplete/issues/654
  r_pprint ${3:-8} bold "${2:-󰌕} ${5:-%d}${${4:+ $4}:-}"
  zstyle ":completion:*${1:+:$1}" format $REPLY
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

# docker
_tagfmt containers-running 
_tagfmt containers-stopped 
_tagfmt context-list 
_tagfmt docker-images 
_tagfmt docker-repos 
_tagfmt networks-list 
_tagfmt nodes-list 
_tagfmt plugins-list 
_tagfmt secrets-list 
_tagfmt services-list  # 
_tagfmt stacks-list 
_tagfmt volumes-list 

unfunction _tagfmt
