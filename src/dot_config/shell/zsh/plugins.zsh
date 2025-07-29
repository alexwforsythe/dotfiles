#!/usr/bin/env zsh
# shellcheck shell=bash

#
# plugins.zsh: defines the list of enabled zsh plugins and loads them.
#
# Example: https://github.com/mattmc3/zsh_unplugged/blob/main/examples/antidote_lite_example.zsh
#

# Define pmodload as a no-op because prezto modules call it to load prereq
# modules. This means the order of modules in $plugins is extra important.
pmodload() {}

plugins=(
    # prezto modules
    #
    # From the READMEs:
    #  - first: helper -> environment
    #  - spectrum -> gnu-utility -> utility -> git/node/python -> completion
    #  - history?
    #  - completion -> fzf-tab -> autosuggestions
    #  - syntax-highlighting -> editor -> history-substring-search -> autosuggestions -> prompt
    #
    # load the config first
    $ZDOTDIR/.zpreztorc
    prezto/helper
    prezto/environment
    prezto/spectrum
    prezto/utility
    prezto/git
    prezto/completion
    prezto/history
    prezto/syntax-highlighting
    prezto/editor
    prezto/history-substring-search
    prezto/autosuggestions
    prezto/directory
    prezto/command-not-found
    prezto/ssh
    prezto/docker
    # prezto/python
    # @todo for some reason it always causes the "no nested sessions" warning
    # even if we comment the entire module... why?
    # prezto/tmux

    # other plugins:
    # zsh-autopair
    zsh-autocomplete
    # forgit
    # fzf-tab

    # prompt: loads last because it depends on other modules, but others don't
    # depend on it
    powerlevel10k
)

autoload -Uz load-plugins
load-plugins $plugins

# Remove pmodload now that all prezto modules have been loaded.
unfunction pmodload
