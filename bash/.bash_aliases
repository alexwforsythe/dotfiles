# Custom bash aliases

alias c="clear; ls"

# directories
alias work="cd $WORKSPACE"

# grep
alias cgrep="grep --color=always"
alias pygrep="grep --include=*.py"
alias jgrep="grep --include=*.java"
alias jsgrep="grep --include=*.js"

# git
alias gis="git status"
alias gcpa="git cherry-pick --abort"
alias gcpc="git cherry-pick --continue"
alias gcop="git checkout '@{-1}'"
alias gwip="git add -A && git commit -m 'wip'"

# Other alias files

WORK_ALIASES="$HOME/.work_aliases"
[[ -s $WORK_ALIASES ]] && source $WORK_ALIASES 
