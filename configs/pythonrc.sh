#!/usr/bin/env bash

#
# Python
#

setup:pyenv() {
    if ! iscmd pyenv; then
        python_bin_dir="/usr/local/bin"
        return
    fi

    # Output of pyenv init zsh/bash:
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

    # @todo cache
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

    # @todo
    # Install pipenv if missing:
    # https://pipenv.pypa.io/en/latest/installation.html
    # if ! pip3 install --user pipenv; then
    #     log:error "module not installed: pipenv"
    #     return 1
    # fi
    export PIPENV_PYTHON="$PYENV_ROOT/shims/python"

    # export WORKON_HOME=$HOME/.virtualenvs
    # export PROJECT_HOME=$HOME/workspace
}

if ! iscmd python3; then
    log:debug "command not found: python3"
    return
fi

if ! setup:pyenv; then
    return 1
fi

# Add symlinks for python, pip, etc.
# @audit already have one in path under ~/.pyenv/shims
# path-append "$HOMEBREW_PREFIX/opt/python/libexec/bin"

# Add user site packages installed via pip.
# @audit pip3 already installs these bins in /opt/homebrew/bin
# path-append "$(python3 -m site --user-base)/bin"

setup:pipenv "$python_bin_dir"
