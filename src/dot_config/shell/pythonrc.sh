#!/usr/bin/env bash

#
# Python
#

setup:pyenv() {
    if ! iscmd pyenv; then
        python_bin_dir="/usr/local/bin"
        return
    fi

    # Load pyenv automatically (output of `pyenv init {bash,zsh}`):
    export PYENV_ROOT="$HOME/.pyenv"
    if [ -d "$PYENV_ROOT/bin" ]; then
        export PATH="$PYENV_ROOT/bin:$PATH"
    fi

    # Install pyenv as a shell function and enable shims & autocompletion:
    # https://github.com/pyenv/pyenv#set-up-your-shell-environment-for-pyenv
    if ! eval "$(pyenv init -)"; then
        log:error "command failed: pyenv init"
        return 1
    fi

    export PYENV_ROOT="$HOME/.pyenv"
    python_bin_dir="$(pyenv prefix)/bin"
}

setup:pipenv() {
    if [ ! -d "$python_bin_dir" ]; then
        log:error "dir not found: $python_bin_dir"
        return 1
    fi

    # Install pip if missing: https://pip.pypa.io/en/stable/installation/
    if ! iscmd pip3; then
        if ! python3 -m ensurepip --upgrade; then
            log:error "module not installed: pip3"
            return 1
        fi
    fi

    export PIPENV_PYTHON="$PYENV_ROOT/shims/python"
}

if ! iscmd python3; then
    log:debug "command not found: python3"
    return
fi

if ! setup:pyenv; then
    return 1
fi

setup:pipenv "$python_bin_dir"
