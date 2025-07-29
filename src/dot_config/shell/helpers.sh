#!/usr/bin/env bash

#
# helpers.sh: shared helper functions for other shell configs.
#
#  - Sourced by .bash_profile and .zprofile before the environment is set up
#  - Should not assume existence of any user env vars, functions, or paths
#

#
# Logging
#

log_level_debug=1
log_level_info=2
log_level_warn=3
log_level_error=4

if [ -z "$RC_LOG_LEVEL" ]; then
    export RC_LOG_LEVEL=$log_level_debug
fi

_red=$'\e[1;31m'
_grn=$'\e[1;32m'
_yel=$'\e[1;33m'
_blu=$'\e[1;34m'
_mag=$'\e[1;35m'
_cyn=$'\e[1;36m'
_end=$'\e[0m'

log:debug() { ((RC_LOG_LEVEL > log_level_debug)) || printf "[${_cyn}debug${_end}] %s\n" "$@"; }
log:info() { ((RC_LOG_LEVEL > log_level_info)) || printf "[${_grn}info${_end}] %s\n" "$@"; }
log:warn() { ((RC_LOG_LEVEL > log_level_warn)) || printf "[${_yel}warn${_end}] %s\n" "$@"; }
log:error() { ((RC_LOG_LEVEL > log_level_error)) || printf "[${_red}error${_end}] %s\n" "$@" >&2; }

#
# Helpers
#

# @todo run:if-dir
run:if-path() {
    if [ ! -d "$1" ]; then
        log:warn "path not found: $1"
        return 1
    fi

    "${@:2}"
}

path-prepend() {
    if [ $# -lt 2 ]; then
        export PATH=${1:+${1}:}$PATH
    else
        oldIFS="$IFS"
        IFS=':'
        export PATH="$*:$PATH"
        IFS="$oldIFS"
    fi
}

path-append() {
    if [ $# -lt 2 ]; then
        export PATH=${PATH:+${PATH}:}$1
    else
        oldIFS="$IFS"
        IFS=':'
        export PATH="${PATH:+${PATH}:}$*"
        IFS="$oldIFS"
    fi
}

source:file() {
    if [ ! -r "$1" ]; then
        log:warn "file not found: $1"
        return 1
    fi

    # shellcheck source=/dev/null
    if ! source "$1"; then
        log:error "file not loaded: $1"
        return 1
    fi

    log:debug "file loaded: $1"
}

# @todo test commands with spaces. do we really need this?
run-cmds() {
    for cmd; do
        $cmd
    done
}

run:if-file() {
    if [[ ! -r $1 ]]; then
        log:warn "file not found: $1"
        return 1
    fi

    "${@:2}"
}

iscmd() {
    hash "$1" >/dev/null 2>&1
}

run:if-cmd() {
    if ! iscmd "$1"; then
        log:warn "command not found: $1"
        return 127
    fi

    "${@:2}"
}

run:if-not-cmd() {
    if ! iscmd "$1"; then
        "${@:2}"
    fi
}

eval:if-cmd() {
    run:if-cmd "$1" eval "$("${@:2}")"
}
