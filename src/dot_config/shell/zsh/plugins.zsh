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
    #  - spectrum -> gnu-utility -> utility -> archive
    #  - utility -> git/node/python -> completion
    #  - completion -> fzf-tab -> autosuggestions
    #  - editor -> anything that uses bindkey, e.g. zsh-autocomplete
    #  - syntax-highlighting -> history-substring-search -> autosuggestions ->
    #    prompt
    #
    # autocomplete -> {compinit,syntax-highlighting,autosuggestions}:
    # https://github.com/marlonrichert/zsh-autocomplete/discussions/808#discussioncomment-13648377
    #
    # load the config first
    $ZDOTDIR/.zpreztorc
    prezto/helper
    prezto/environment
    prezto/spectrum
    prezto/gnu-utility
    prezto/utility
    prezto/archive
    prezto/editor
    prezto/git

    # zsh-users/zsh-completions: still in prezto until we stop using
    # prezto/completion:
    prezto/completion/external
    zsh-autocomplete

    prezto/history
    prezto/syntax-highlighting
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
    select-bracketed
    select-quoted
    vim-surround
    run-help
    # zsh-autopair
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
