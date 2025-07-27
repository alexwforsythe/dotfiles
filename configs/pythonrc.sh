#!/usr/bin/env bash

#
# Python
#

setup:pyenv() {
    if ! iscmd pyenv; then
        python_bin_dir="/usr/local/bin"
        return
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

setup:virtualenvwrapper() {
    if [[ ! -d $python_bin_dir ]]; then
        log:error "dir not found: $python_bin_dir"
        return 1
    fi

    # Install pip if missing: https://pip.pypa.io/en/stable/installation/
    if ! command -v pip >/dev/null; then
        if ! python -m ensurepip --upgrade; then
            log:error "module not installed: pip"
            return 1
        fi
    fi

    # Source the lazy loader for faster shellcheck startup.
    local venvwrapper_path=$python_bin_dir/virtualenvwrapper_lazy.sh

    if [[ ! -f $venvwrapper_path ]]; then
        if pip show virtualenvwrapper >/dev/null; then
            log:warn "file not found: $venvwrapper_path"
            return 1
        fi

        # Install virtualenvwrapper if missing
        if ! pip install virtualenvwrapper; then
            log:error "module not installed: virtualenvwrapper"
            return 1
        fi
    fi

    if [[ ! -f $venvwrapper_path ]]; then
        log:warn "file not found: $venvwrapper_path"
        return 1
    fi

    export WORKON_HOME=$HOME/.virtualenvs
    export PROJECT_HOME=$HOME/workspace
    export VIRTUALENVWRAPPER_SCRIPT=$python_bin_dir/virtualenvwrapper.sh
    source:file "$venvwrapper_path"
}

if ! command -v python >/dev/null; then
    log:debug "command not found: python"
    return
fi

if ! setup:pyenv; then
    return 1
fi

setup:virtualenvwrapper "$python_bin_dir"
