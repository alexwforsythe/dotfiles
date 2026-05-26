#!/usr/bin/env zsh
# shellcheck shell=bash

plugins=(
    # Load first so the prompt is ready ASAP.
    p10k-instant-prompt

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
    $ZDOTDIR/.zpreztorc # @todo to .config
    prezto/helper
    prezto/environment
    prezto/spectrum
    prezto/gnu-utility
    prezto/utility
    prezto/archive
    prezto/editor
    prezto/git

    # Load completion definitions before zsh-autocomplete because it calls
    # compinit.
    zsh-completions
    external-completions
    zsh-autocomplete

    prezto/history
    prezto/syntax-highlighting
    # Incompatible with zsh-autocomplete:
    # prezto/history-substring-search
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
    cdr
    # forgit
    # fzf-tab
    dbt

    # prompt: loads last because it depends on other modules, but others don't
    # depend on it
    powerlevel10k
)
