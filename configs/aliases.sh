#!/usr/bin/env bash

uptime-trimmed() {
    val=$(uptime)
    trimmed=$(printf '%s' "$val#$val%%[![:space:]]*")
    echo "$trimmed" | tr -s '[:blank:],' ',' | cut -d ',' -f 3-4
}

# @todo: more from https://github.com/rothgar/mastering-zsh/blob/master/docs/helpers/functions.md
do-matrix() {
    echo -e "\e[1;40m"
    clear
    while :; do
        echo $LINES $COLUMNS $((RANDOM % COLUMNS)) $((RANDOM % 72))
        sleep 0.05
    done | awk '{ \
        letters="abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789@#$%^&*()" \
        c=$4 \
        letter=substr(letters,c,1) \
        a[$3]=0 \
        for (x in a) { \
            o=a[x];a[x]=a[x]+1 \
            printf "\033[%s;%sH\033[2;32m%s",o,x,letter \
            printf "\033[%s;%sH\033[1;37m%s\033[0;0H",a[x],x,letter \
            if (a[x] >= $1) { \
                a[x]=0; \
            } \
        } \
    }'
}

show-colors() {
    # echo colors
    for C in {0..255}; do
        tput setab "$C"
        echo -n "$C "
    done
    tput sgr0
    echo
    # for i in {0..255}; do
    #     print -Pn "%K{$i}  %k%F{$i}${(l:3::0:)i}%f " ${${(M)$((i%6)):#3}:+$'\n'}
    # done
    # x=$(tput op)
    # y=$(printf %76s)
    # for i in {0..256}; do
    #     o=00$i
    #     echo -e "${o:${#o}-3:3}" "$(
    #         tput setaf "$i"
    #         tput setab "$i"
    #     )${y// /=}$x"
    # done
}

#
# More git aliases. The base ones are defined by prezto/modules/git.
#

alias gis="git status"
alias gbl='git branch --verbose -v'
alias gpr="git pull --rebase origin master"
alias gcpa="git cherry-pick --abort"
alias gcpc="git cherry-pick --continue"
alias gcop="git checkout '@{-1}'"
alias gwip="git add -A && git commit -m 'wip'"
alias grim="git rebase --interactive \$(git merge-base HEAD origin/master)"
