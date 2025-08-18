#!/usr/bin/env zsh
# shellcheck shell=bash

#
# run-help: loads the run-help function and sets HELPDIR so it knows where to
# search for help functions.
#
# https://zsh.sourceforge.io/Doc/Release/User-Contributions.html#Accessing-On_002dLine-Help
#

# Find and set the HELPDIR.
helpdirs=(
  $HOMEBREW_PREFIX/share/zsh/help(/N)
  /usr/local/share/zsh/help(/N)
  /usr/share/zsh/$ZSH_VERSION/help(/N)
  /usr/share/zsh/help(/N)
)
if (( $#helpdirs == 0 )); then
    return 0
fi
export HELPDIR=${helpdirs[1]}

# Load run-help.
autoload -Uz run-help
