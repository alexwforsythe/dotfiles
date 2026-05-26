#!/usr/bin/env zsh
# shellcheck shell=bash

#
# completions/register.zsh: adds external completion definitions (e.g. homebrew)
# to fpath so they will be picked up by the completion system.
#  - Should be loaded before any plugins that might call compinit, e.g.
#    zsh-autocomplete
#
# @todo I needed to run these commands to fix zcompinit security issues from
# docker completions:
#
#     compaudit | xargs chown -R $(whoami)
#     compaudit | xargs chmod go-w
#

# @audit needed?
# Load complist before compinit so the widget can be redefined by the completion
# system.
# https://zsh.sourceforge.io/Doc/Release/Completion-System.html#Use-of-compinit
zmodload -i zsh/complist

#
# homebrew
#
# Register homebrew completions so they'll be loaded by the completion plugin.
#  - completions/zsh: completions for the brew command
#  - share/zsh/site-functions: completions for commands installed via brew
#  - share/bash-completion/completions: bash completions in zsh format (in case
#    one isn't defined in zsh/site-functions)
#

if [ -n "$HOMEBREW_PREFIX" ]; then
  fpath+=("$HOMEBREW_PREFIX"/share/bash-completion/completions)
  # shellcheck disable=1036,2128,2206
  fpath=(
    "$HOMEBREW_PREFIX"/completions/zsh(/N)
    "$HOMEBREW_PREFIX"/share/zsh/site-functions(/N)
    /usr/share/zsh/site-functions(/N)
    $fpath
  )

  # The git completions installed by brew are worse than the default ones that
  # ship with zsh, so disable them via renaming.
  for f in _git git-completion.bash; do
    if [ -r "$HOMEBREW_PREFIX/share/zsh/site-functions/$f" ]; then
      # @note -f isn't posix compliant, but it's supported by most shells
      mv -f "$HOMEBREW_PREFIX/share/zsh/site-functions/$f" "$HOMEBREW_PREFIX/share/zsh/site-functions/disabled_$f"
    fi
  done
fi

# gcloud
# @audit loads compinit and doesn't even compdef _gcloud
# if [ -d "$HOMEBREW_PREFIX" ]; then
#     source:file "$HOMEBREW_PREFIX/share/google-cloud-sdk/completion.zsh.inc"
# fi

# ngrok
# @todo cache to file, change on upgrade (or just cache eval)
# eval:if-cmd ngrok ngrok completion
