#!/usr/bin/env zsh
# shellcheck shell=bash

#
# zsh-autocomplete.zsh: configures zsh-autocomplete and should be loaded before
# the plugin
#
# https://github.com/marlonrichert/zsh-autocomplete/blob/main/.zshrc
#

# zsh-autocomplete styles

# Load and initialize the completion system--ignoring insecure directories--with
# a cache time of 20 hours, so it should almost always recompile if completions
# changed the first time a shell is opened each day.
#
# Source: https://github.com/sorin-ionescu/prezto/blob/master/modules/completion/init.zsh
if [[ $ZCOMPDUMP(#qNmh-20) ]]; then
    # -C (skip function check) implies -i (skip security check).
    zstyle ':autocomplete::compinit' arguments -C
else
    # Note: compinit only recompiles completions if the number of functions
    # changes, not necessarily if any are updated.
    zstyle ':autocomplete::compinit' arguments -i
    # Keep $ZCOMPDUMP younger than cache time even if it isn't regenerated.
    # Source: https://github.com/sorin-ionescu/prezto/issues/1880
    run:if-file $ZCOMPDUMP touch -m $ZCOMPDUMP
fi

# Wait this many seconds for typing to stop, before showing completions:
zstyle ':autocomplete:*' delay 0.3 # seconds (float)

# Waits at most this many seconds for completion to finish:
zstyle ':autocomplete:*' timeout 2.0 # seconds (float)

# Wait until this many characters have been typed, before showing completions:
zstyle ':autocomplete:*' min-input 2 # characters (int)

# Stop completions from showing whenever the current word consists of two or
# more dots:
zstyle ':autocomplete:*' ignored-input '..##'

# Add a space after these completions:
# (default:)
# zstyle ':autocomplete:*' add-space \
#     executables aliases functions builtins reserved-words commands

# Make any completion widget first insert the longest sequence of characters
# that will complete to all completions shown, if any, before inserting actual
# completions.
zstyle ':autocomplete:*' insert-unambiguous yes
# all tab widgets
zstyle ':autocomplete:*complete*:*' insert-unambiguous yes
# all history widgets
zstyle ':autocomplete:*history*:*' insert-unambiguous yes
# ^S
zstyle ':autocomplete:menu-search:*' insert-unambiguous yes
# When using the above, if you want each widget to first try to insert only the
# longest prefix that will complete to all completions shown, if any, then add
# the following:
# zstyle ':completion:*:*' matcher-list 'm:{[:lower:]-}={[:upper:]_}' '+r:|[.]=**'
# Note, though, that this will also slightly change what completions are listed
# initially. This is a limitation of the underlying implementation in Zsh.

# You can customize the way the common substring is presented. The following
# sets the presentation to the default:
# @audit what does this do, can't see it
# builtin zstyle ':autocomplete:*:unambiguous' format \
#     $'%{\e[0;2m%}%Bcommon substring:%b %0F%11K%d%f%k'

# This will make zsh-autocomplete behave as if you pressed ctrl+r at the start
# of each new command line:
# zstyle ':autocomplete:*' default-context history-incremental-search-backward

# @todo rename this file, and source zsh-autocomplete here and the replace the
# plugin with this script (like prezto wrappers)
