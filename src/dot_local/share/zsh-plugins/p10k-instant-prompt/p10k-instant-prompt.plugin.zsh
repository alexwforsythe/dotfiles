#!/usr/bin/env zsh
# shellcheck shell=bash

#
# p10k-instant-prompt: activates instant prompt for powerlevel10k
#  - Initialization code that may require console input (password prompts, [y/n]
#    confirmations, etc.) must be loaded before this plugin
#  - All other plugins should be loaded after it so the prompt renders ASAP
#  - tmux sessions should be created after instant prompt because tmux generates
#    output to parent process:
#    https://github.com/romkatv/powerlevel10k/issues/1203
#
# https://github.com/romkatv/powerlevel10k#how-do-i-configure-instant-prompt
#

# Activate direnv before instant prompt for compatibility, if a .env* file is
# present:
# https://github.com/romkatv/powerlevel10k/blob/master/README.md#how-do-i-initialize-direnv-when-using-instant-prompt
# shellcheck disable=2144,2157
if iscmd direnv && [[ -n .env*(#q-.N) ]]; then
  direnv export zsh
fi

# powerlevel10k already handles zcompiling this file, so don't add it directly
# to plugins.zsh.
source:file $XDG_CACHE_HOME/p10k-instant-prompt-${(%):-%n}.zsh
