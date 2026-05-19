#!/usr/bin/env bash

#
# helpers.sh: shared helper functions for other shell configs.
#
#  - Sourced by .bash_profile and .zprofile before the environment is set up
#  - Should not assume existence of any user env vars, functions, or paths
#

#
# Colors
#
# https://github.com/zdharma/color
#

# usage: pprint(color, style?)
function pprint() {
    local fg
    case $1 in
    black | b) fg='30' ;;
    red | r) fg='31' ;;
    green | g) fg='32' ;;
    yellow | y) fg='33' ;;
    blue | bl) fg='34' ;;
    magenta | m) fg='35' ;;
    cyan | c) fg='36' ;;
    white | w) fg='37' ;;
    # Fall back to 256-color mode.
    *) fg="38;5;$1" ;;
    esac
    shift

    local style=0
    case $1 in
    bold | b) style=1 && shift ;;
    italic | i) style=2 && shift ;;
    underline | u) style=4 && shift ;;
    inverse | in) style=7 && shift ;;
    strikethrough | s) style=9 && shift ;;
    esac

    printf '\033[%d;%sm%s\033[0;m' $style "$fg" "$@"
}

#
# Logging
#

log_level_debug=1
log_level_info=2
log_level_warn=3
log_level_error=4

export RC_LOG_LEVEL=$log_level_debug

_pre_debug=$(pprint c b "debug ")
_pre_info=$(pprint g b "info ")
_pre_warn=$(pprint y b "warn ")
_pre_error=$(pprint r b "error ")

log:debug() { ((RC_LOG_LEVEL > log_level_debug)) || printf '%s %s\n' "$_pre_debug" "$@"; }
log:info() { ((RC_LOG_LEVEL > log_level_info)) || printf '%s %s\n' "$_pre_info" "$@"; }
log:warn() { ((RC_LOG_LEVEL > log_level_warn)) || printf '%s %s\n' "$_pre_warn" "$@"; }
log:error() { ((RC_LOG_LEVEL > log_level_error)) || printf '%s %s\n' "$_pre_error" "$@" >&2; }

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
    if [ ! -r "$1" ]; then
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
