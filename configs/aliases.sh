#!/usr/bin/env bash

# git (extends prezto/modules/git)
alias gis="git status"
alias gbl='git branch --verbose -v'
alias gpr="git pull --rebase origin master"
alias gcpa="git cherry-pick --abort"
alias gcpc="git cherry-pick --continue"
alias gcop="git checkout '@{-1}'"
alias gwip="git add -A && git commit -m 'wip'"
alias grim="git rebase --interactive \$(git merge-base HEAD origin/master)"

# docker (extends prezto/modules/docker)
alias dkB="docker builder"
alias dkBpr="docker builder prune"
alias dkBprA="docker builder prune --all"
alias dkprA="docker container prune && docker image prune && docker volume prune"
