#!/usr/bin/env bash

#
# General
#

# Print the PATH with new lines.
alias ppath="echo \${PATH//:/\n}"
alias sudo="sudo --preserve-env=VISUAL,EDITOR,GIT_EDITOR"
alias v="\$VISUAL"

alias sa="alias | fzf"
alias senv="env | fzf"
alias spath="ppath | fzf"

# Use Xcode make on MacOS to override any other versions that might be
# added later.
if $IS_MACOS; then
    run:if-file /Library/Developer/CommandLineTools/usr/bin/make \
        alias make=/Library/Developer/CommandLineTools/usr/bin/make
fi

#
# chezmoi: https://github.com/mass8326/zsh-chezmoi/blob/main/chezmoi.plugin.zsh
#

# Status
alias ch="chezmoi"
alias chd="chezmoi diff"
alias chst="chezmoi status"
alias chdoc="chezmoi doctor"

# Editing source
alias cha="chezmoi add"
alias chr="chezmoi re-add"
alias che="chezmoi edit"
alias chea="chezmoi edit --apply"
alias chcd="chezmoi cd"

# Updating target
alias chap="chezmoi apply"
alias chup="chezmoi update"
alias chug="chezmoi upgrade"

#
# git: extends prezto/modules/git
#

alias gis="git status"
alias gbl='git branch --verbose -v'
alias gpr="git pull --rebase origin master"
alias gcpa="git cherry-pick --abort"
alias gcpc="git cherry-pick --continue"
alias gcop="git checkout '@{-1}'"
alias gwip="git add -A && git commit -m 'wip'"
alias grim="git rebase --interactive \$(git merge-base HEAD origin/master)"

#
# docker: extends prezto/modules/docker
#
alias dkB="docker builder"
alias dkBpr="docker builder prune"
alias dkBprA="docker builder prune --all"
alias dkprA="docker container prune && docker image prune && docker volume prune"

#
# Helpers
#

# Go up N directories (default is 1).
# https://github.com/peterhurford/up.zsh
up() {
    if [ $# -eq 0 ]; then
        cd ..
    elif ! [[ $1 =~ ^[0-9]+$ ]]; then
        log:error "Number of up dirs must be between at least 1"
        return 2
    else
        local d=""
        for ((i = 1; i <= $1; i++)); do
            if [ -n "$d" ]; then d+=/; fi
            d+=..
        done
        cd "$d" || return 1
    fi
}
