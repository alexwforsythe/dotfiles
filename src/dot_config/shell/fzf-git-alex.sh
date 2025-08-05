#!/usr/bin/env bash

if [ -n "$TMUX" ] && [ "$FZF_TMUX" -gt 0 ]; then
    _log_msg() { tmux display-message " $1"; }
else
    _log_msg() { printf "%s\n" "$1" >&2; }
fi

_log_info() { _log_msg "[info] $1"; }
_log_warn() { _log_msg "[warn] $1"; }
_log_error() { _log_msg "[error] $1"; }

_inside_work_tree() {
    git rev-parse --is-inside-work-tree >/dev/null
}

_reverse_lines() {
    tac 2>/dev/null
}

_assert_in_git_repo() {
    git rev-parse HEAD >/dev/null 2>&1 && return 0
    _log_error "Not in a git repository"
    return 1
}

case "$#" in
0) ;;
1)
    branches() {
        git branch "$@" \
            --sort=-committerdate \
            --sort=-HEAD \
            --format='%(HEAD) %(color:yellow)%(refname:short) %(color:green)(%(committerdate:relative))\t%(color:blue)%(subject)%(color:reset)' \
            --color=always |
            column -t -s $'\t'
    }

    refs() {
        git for-each-ref \
            --sort=-creatordate \
            --sort=-HEAD \
            --color=always \
            --format='%(refname) %(color:green)(%(creatordate:relative))\t%(color:blue)%(subject)%(color:reset)' |
            eval "$1" |
            sed 's#^refs/remotes/#\x1b[95mremote-branch\t\x1b[33m#; s#^refs/heads/#\x1b[92mbranch\t\x1b[33m#; s#^refs/tags/#\x1b[96mtag\t\x1b[33m#; s#refs/stash#\x1b[91mstash\t\x1b[33mrefs/stash#' |
            column -t -s $'\t'
    }

    case "$1" in
    branches)
        printf "CTRL-O (open in browser) \u2571 ALT-A (show all branches)\n\n"
        branches
        ;;
    all-branches)
        printf "CTRL-O (open in browser)\n\n"
        branches -a
        ;;
    refs)
        printf "CTRL-O (open in browser) \u2571 ALT-E (examine in editor) \u2571 ALT-A (show all refs)\n\n"
        refs 'grep -v ^refs/remotes'
        ;;
    all-refs)
        printf "CTRL-O (open in browser) \u2571 ALT-E (examine in editor)\n\n"
        refs 'cat'
        ;;
    nobeep) ;;
    *)
        printf "Invalid command: %s\n" "$1" " " >&2
        exit 2
        ;;
    esac
    ;;
*)
    set -e

    branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
    if [ "$branch" = HEAD ]; then
        branch=$(git describe --exact-match --tags 2>/dev/null || git rev-parse --short HEAD)
    fi

    # Only supports GitHub for now
    case "$1" in
    commit)
        hash=$(echo "$2" | grep -o "[a-f0-9]\{7,\}")
        path=/commit/$hash
        ;;
    branch | remote-branch)
        branch=$(echo "$2" | sed -e 's/^[* ]*//' | cut -d ' ' -f 1)
        remote=$(git config branch."$branch".remote || echo 'origin')
        branch="$branch#$remote/"
        path=/tree/$branch
        ;;
    remote)
        remote=$2
        path=/tree/$branch
        ;;
    file) path=/blob/$branch/$(git rev-parse --show-prefix)$2 ;;
    tag) path=/releases/tag/$2 ;;
    *) exit 1 ;;
    esac

    remote=${remote:-$(git config branch."${branch}".remote || echo 'origin')}
    remote_url=$(git remote get-url "$remote" 2>/dev/null || echo "$remote")

    url="$remote_url%.git"
    case "$remote_url" in
    git@*) url="https://$url#git@/://" ;;
    http*) ;;
    *)
        printf "Invalid URL for branch %s: %s\n" "$branch" "$remote_url"
        exit 1
        ;;
    esac

    case "$(uname -s)" in
    Darwin) open "$url$path" ;;
    *) xdg-open "$url$path" ;;
    esac

    exit 0
    ;;
esac

__fzf_git=$(readlink -f "$0")
if [ -z "$__fzf_git" ]; then
    printf "Couldn't read .fzf_git\n"
    exit 1
fi

# Redefine this function to change the options
_fzf_git_fzf() {
    # --preview-window='right,50%,border-left' \
    # --bind='ctrl-/:change-preview-window(down,50%,border-top|hidden|)' \
    fzf --border "$@"
}

if [ -z "$_fzf_git_cat" ]; then
    export _fzf_git_cat="cat"
    if command -v bat >/dev/null; then
        _fzf_git_cat="bat $_fzf_git_bat_options"
        _fzf_git_bat_options="--style='${BAT_STYLE:-full}' --color=always --pager=never"
    fi
fi

_fzf_git_files() {
    _fzf_git_check || return
    (
        git -c color.status=always status --short
        git ls-files | grep -vxFf <(
            git status -s | grep '^[^?]' | cut -c 4-
            echo :
        ) | sed 's/^/   /'
    ) |
        _fzf_git_fzf -m --ansi --nth 2..,.. \
            --prompt '📁 Files> ' \
            --header 'CTRL-O (open in browser) \u2571 ALT-E (open in editor)\n\n' \
            --bind "ctrl-o:execute-silent:bash $__fzf_git file {-1}" \
            --bind "alt-e:execute:${EDITOR:-vim} {-1} > /dev/tty" \
            --preview "git diff --no-ext-diff --color=always -- {-1} | sed 1,4d; $_fzf_git_cat {-1}" "$@" |
        cut -c 4- | sed 's/.* -> //'
}

_fzf_git_branches() {
    _fzf_git_check || return
    bash "$__fzf_git" branches |
        _fzf_git_fzf --ansi \
            --prompt '🌲 Branches> ' \
            --header-lines 2 \
            --tiebreak begin \
            --preview-window down,border-top,40% \
            --color hl:underline,hl+:underline \
            --no-hscroll \
            --bind 'ctrl-/:change-preview-window(down,70%|hidden|)' \
            --bind "ctrl-o:execute-silent:bash $__fzf_git branch {}" \
            --bind "alt-a:change-prompt(🌳 All branches> )+reload:bash \"$__fzf_git\" all-branches" \
            --preview "git log --oneline --graph --date=short --color=always --pretty='format:%C(auto)%cd %h%d %s' \$(echo {} | sed s/^..// | cut -d ' ' -f 1)" "$@" |
        sed 's/^..//' | cut -d ' ' -f 1
}

_fzf_git_tags() {
    _fzf_git_check || return
    git tag --sort -version:refname |
        _fzf_git_fzf --preview-window right,70% \
            --prompt '📛 Tags> ' \
            --header 'CTRL-O (open in browser)\n\n' \
            --bind "ctrl-o:execute-silent:bash $__fzf_git tag {}" \
            --preview 'git show --color=always {}' "$@"
}

_fzf_git_hashes() {
    _fzf_git_check || return
    git log --date=short --format="%C(green)%C(bold)%cd %C(auto)%h%d %s (%an)" --graph --color=always |
        _fzf_git_fzf --ansi --no-sort --bind 'ctrl-s:toggle-sort' \
            --prompt '🍡 Hashes> ' \
            --header 'CTRL-O (open in browser) \u2571 CTRL-D (diff) \u2571 CTRL-S (toggle sort)\n\n' \
            --bind "ctrl-o:execute-silent:bash $__fzf_git commit {}" \
            --bind 'ctrl-d:execute:echo {} | grep -o "[a-f0-9]\{7,\}" | head -n 1 | xargs git diff > /dev/tty' \
            --color hl:underline,hl+:underline \
            --preview 'echo {} | grep -o "[a-f0-9]\{7,\}" | head -n 1 | xargs git show --color=always' "$@" |
        awk 'match($0, /[a-f0-9][a-f0-9][a-f0-9][a-f0-9][a-f0-9][a-f0-9][a-f0-9][a-f0-9]*/) { print substr($0, RSTART, RLENGTH) }'
}

_fzf_git_remotes() {
    _fzf_git_check || return
    git remote -v | awk '{print $1 "\t" $2}' | uniq |
        _fzf_git_fzf --tac \
            --prompt '📡 Remotes> ' \
            --header 'CTRL-O (open in browser)\n\n' \
            --bind "ctrl-o:execute-silent:bash $__fzf_git remote {1}" \
            --preview-window right,70% \
            --preview "git log --oneline --graph --date=short --color=always --pretty='format:%C(auto)%cd %h%d %s' {1}/'\$(git rev-parse --abbrev-ref HEAD)'" "$@" |
        cut -d '\t' -f 1
}

_fzf_git_stashes() {
    _fzf_git_check || return
    git stash list | _fzf_git_fzf \
        --prompt '🥡 Stashes> ' \
        --header 'CTRL-X (drop stash)\n\n' \
        --bind 'ctrl-x:execute-silent(git stash drop {1})+reload(git stash list)' \
        --delimiter=':' \
        --preview 'git show --color=always {1}' "$@" |
        cut -d ':' -f 1
}

_fzf_git_each_ref() {
    _fzf_git_check || return
    bash "$__fzf_git" refs | _fzf_git_fzf --ansi \
        --nth 2,2.. \
        --tiebreak begin \
        --prompt '☘️  Each ref> ' \
        --header-lines 2 \
        --preview-window down,border-top,40% \
        --color hl:underline,hl+:underline \
        --no-hscroll \
        --bind 'ctrl-/:change-preview-window(down,70%|hidden|)' \
        --bind "ctrl-o:execute-silent:bash $__fzf_git {1} {2}" \
        --bind "alt-e:execute:${EDITOR:-vim} <(git show {2}) > /dev/tty" \
        --bind "alt-a:change-prompt(🍀 Every ref> )+reload:bash \"$__fzf_git\" all-refs" \
        --preview 'git log --oneline --graph --date=short --color=always --pretty="format:%C(auto)%cd %h%d %s" {2}' "$@" |
        awk '{print $2}'
}
