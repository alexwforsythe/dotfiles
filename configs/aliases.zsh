#!/usr/bin/env zsh
# shellcheck shell=bash

#
# --help
#
# Alias common help commands to pipe output to bat for syntax highlighting and
# paging. Exclude -h because it commonly means human-readable or something else.
#
# https://github.com/sharkdp/bat?tab=readme-ov-file#highlighting---help-messages
#

if iscmd bat; then
    for flag in help help-all help-list help-hidden help-list-hidden longhelp fullhelp; do
        for pre in -- -; do
            alias -g -- "$pre$flag=$pre$flag 2>&1 | bat --plain --language=help"
        done
    done
fi
