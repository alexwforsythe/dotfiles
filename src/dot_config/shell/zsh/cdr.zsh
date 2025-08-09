#!/usr/bin/env zsh
# shellcheck shell=bash

#
# cdr.zsh: sets up the cdr command to track and jump to recent directories.
#
# https://zsh.sourceforge.io/Doc/Release/User-Contributions.html#Recent-Directories
#

autoload -Uz cdr chpwd_recent_dirs add-zsh-hook
add-zsh-hook chpwd chpwd_recent_dirs
# Make recent dirs available via dynamic dir name syntax.
add-zsh-hook -Uz zsh_directory_name zsh_directory_name_cdr
# Use dir name for completion instead of index, for clearer history.
zstyle ':chpwd:*' recent-dirs-default true
zstyle ':completion:*:*:cdr:*:*' recent-dirs-insert both
# List recent-dirs first in cdr completion menu (we can use cd for normal dirs).
zstyle ':completion:*:*:cdr:*:*' group-order recent-dirs directories
