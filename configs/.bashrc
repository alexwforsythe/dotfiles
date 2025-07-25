#!/usr/bin/env bash

#
# ~/.bashrc: executed by bash for interactive non-login shells
#
# https://www.gnu.org/software/bash/manual/bash.html#Bash-Startup-Files
#

# If not running interactively, don't do anything
case $- in
*i*) ;;
*) return ;;
esac

# Don't put duplicate lines or lines starting with space in the history.
HISTCONTROL=ignoreboth
HISTSIZE=1000
HISTFILESIZE=2000

# Append to the history file, don't overwrite it
shopt -s histappend

# Check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
shopt -s globstar

# Set variable identifying the chroot you work in (used in the prompt below).
if [[ -z ${debian_chroot:-} && -r /etc/debian_chroot ]]; then
    debian_chroot=$(</etc/debian_chroot)
fi

# Set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
xterm-color* | xterm-256color* | tmux*)
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
    ;&
xterm* | rxvt*)
    # If this is an xterm set the title to user@host:dir
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*) PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ ' ;;
esac

#
# Hard dependencies
#

shellrc="$XDG_CONFIG_HOME/configs/shellrc.sh"
source:file "$shellrc" || return 1

#
# Plugins
#

# fzf
setup-fzf "$HOME/.fzf.bash"

#
# Bash completions
#

if ! shopt -oq posix; then
    source:file /usr/share/bash-completion/bash_completion ||
        source:file /etc/bash_completion || {
        [[ -d /usr/local/etc/bash_completion.d ]] &&
            for f in /usr/local/etc/bash_completion.d/*; do source:file "$f"; done
    }
fi

# Use dircolors to set LS_COLORS to a nice theme (its output is the setter
# command).
#
# GNU ls (installed by brew as part of corutils on MacOS) uses LS_COLORS to
# colorize output. Here's a good reference:
# https://the.exa.website/docs/colour-themes
run:if-cmd dircolors eval "$(dircolors)"
