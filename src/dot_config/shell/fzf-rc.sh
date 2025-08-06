#!/bin/env bash

#
# fzf
#
# https://github.com/junegunn/fzf
#
# Guides:
#  - https://thevaluable.dev/fzf-shell-integration
#

# @todo tmux menu for invoking fzf commands
#  - ctrl-r: Paste the selected command from history onto the command-line
#  - ctrl-t: Paste the selected files and directories onto the command-line
#  - alt-c: cd into the selected directory
#    - @todo not working, overridden by zsh binding?
#  - ctrl-r: rg files
#  - edit-command-line (zle widget)
#  - extrakto (tmux plugin)
#
# See https://github.com/junegunn/fzf#key-bindings-for-command-line

#
# Style
#

# @todo z integration: https://github.com/junegunn/fzf/wiki/Examples#z

# @todo start hidden, or maybe as default preview
fzf_header_default="$(
    printf '%s\n' \
        'C-d: Dirs / C-f: Files / C-r: Reload / C-e: Exact' \
        'C-k: Up / C-j: Down / Tab: Select / C-y: Copy / C-/: Preview'
)"
if iscmd column; then
    delim=' / '
    fzf_header_default="$(printf '%s\n' "$fzf_header_default" "$delim " | column -t -s "$delim")"
fi

# Color theme
#
# References:
#  - https://github.com/junegunn/fzf/wiki/Color-schemes
#  - https://github.com/tinted-theming/home/blob/main/styling.md
fzf_theme="\
bg:0,\
bg+:19,\
gutter:18,\
border:18,\
fg:21,\
fg+:7,\
header:20:italic,\
hl:4,\
hl+:12,\
info:3,\
marker:5,\
pointer:6,\
prompt:3,\
spinner:6"

# @todo fill this out
# fzf_syntax_guide="hello im syntax guide.\ndo not use single quotes in here!"
fzf_syntax_guide=$(
    printf '%s\n' \
        'hello im syntax guide' \
        'do not use single quotes here!'
)

# @todo move header stuff into preview too!
#  - how to cycle through them?
fzf_keybinds_guide=$(
    printf '%s\n' \
        'hello im bindings guide' \
        'do not use single quotes here!'
)

#
# Options
#

# @todo add fdignore and common excludes for find
if iscmd fd; then
    header_lines_find=0
    _cmd_find_base=(fd --full-path --strip-cwd-prefix --hidden --follow)
    _cmd_find() {
        case $1 in
        f) echo "${_cmd_find_base[@]}" --type f "$2" ;;
        d) echo "${_cmd_find_base[@]}" --type d "$2" ;;
        *) echo "${_cmd_find_base[@]}" "$1" ;;
        esac
    }
else
    log:warn "command not found: fd"
    header_lines_find=1
    _cmd_find() {
        local _cmd_find_base=(find "$1" \( -path './.git' -o -path './node_modules' \) -prune -false)
        case $1 in
        f) echo "${_cmd_find_base[@]}" -type f ;;
        d) echo "${_cmd_find_base[@]}" -type d ;;
        *) echo "${_cmd_find_base[@]}" ;;
        esac
    }
fi

_find() { eval "$(_cmd_find "$1")"; }

cmd_find_f="$(_cmd_find f)"
cmd_find_d="$(_cmd_find d)"

export FZF_DEFAULT_COMMAND="$cmd_find_f"
export FZF_CTRL_T_COMMAND="$cmd_find_f"
export FZF_ALT_C_COMMAND="$cmd_find_d"

# @todo default binding ctrl-e to toggle --exact (-e)
#  - actually add a hotkey to render syntax guide instead of preview

# @todo set a default binding (ctrl-r) to switch to rg instead of fd!
#  - and use rgp zfunc (highlight w/ delta)
#  - or do we need to set it in comprun to avoid using it for non-file commands?

# Any args containing whitespace need to be wrapped in '' and then "" for array
# expansion to detect the ''.
opts_fzf_default=(
    --ansi
    --layout=reverse
    --info=inline
    --border=none
    "--prompt='fzf> '"
    # --marker="*"
    # --color=16
    --color="$fzf_theme"
)
export FZF_DEFAULT_OPTS="${opts_fzf_default[*]}"

opts_fzf_path=(
    --header="'$fzf_header_default'"
    --header-lines="$header_lines_find"
    --bind 'backward-eof:close'
    --bind 'ctrl-j:down'
    --bind 'ctrl-k:up'
    --bind 'space:toggle+down'
    --bind 'tab:replace-query'
    # --bind 'ctrl-space:jump'
    --bind 'ctrl-s:toggle-sort'
    --bind 'ctrl-/:toggle-preview'
    "--bind 'ctrl-e:change-preview(echo \"$fzf_syntax_guide\")'"
    # "--bind '?:execute(echo $fzf_header_default)'"
    --bind 'ctrl-a:toggle-all'
    # --bind "'ctrl-d:change-prompt(Directories> )+reload($(_cmd_find d '{q}'))'"
    # --bind "'ctrl-f:change-prompt(Files> )+reload($(_cmd_find f '{q}'))'"
    --bind "'ctrl-y:execute-silent(echo -n {2..} | pbcopy)+abort'" # @todo doesn't work
)

# zoxide: https://github.com/ajeetdsouza/zoxide?tab=readme-ov-file#environment-variables
if iscmd tree; then
    cmd_preview_dir="tree -C {} | head -200"
    opts_preview_dir=("$cmd_preview_dir")
    export _ZO_FZF_OPTS="$FZF_DEFAULT_OPTS ${opts_fzf_path[*]} --preview='tree -C {-1} | head -200'"
else
    log:warn "command not found: tree"
    cmd_preview_dir="ls -lahF {} | head -200"
    opts_preview_dir=("$cmd_preview_dir" --header-lines=1)
    export _ZO_FZF_OPTS="$FZF_DEFAULT_OPTS ${opts_fzf_path[*]} --preview='ls -lahF {} | head -200' --header-lines=1"
fi
if iscmd bat; then
    cmd_preview_file="bat --color=always --style=grid,header,header-filesize --line-range :500 {}"
else
    log:warn "command not found: bat"
    cmd_preview_file="cat -n {} | head -500"
fi

opts_preview_path=("[ -d {} ] && $cmd_preview_dir || $cmd_preview_file")
export FZF_CTRL_R_OPTS="--layout=default --preview='echo {}' --preview-window=down:3:hidden:wrap"
export FZF_ALT_C_OPTS="${opts_fzf_path[*]} --preview='${opts_preview_dir[*]}'"
export FZF_CTRL_T_OPTS="${opts_fzf_path[*]} --preview='${opts_preview_path[*]}'"

# Disable fzf tmux popup.
#
# See -p options in tmux manpage.
export FZF_TMUX=0
unset FZF_TMUX_OPTS

#
# Completion
#

opts_fzf_completion=(--border=none)
export FZF_COMPLETION_OPTS="${opts_fzf_completion[*]}"

# Use fd instead of the default find command for listing path/dir candidates.
#  - The first argument to the function ($1) is the base path to start traversal
#  - See the source code (completion.{bash,zsh}) for the details.
_fzf_compgen_path() { _find "$1"; }
_fzf_compgen_dir() { _find d "$1"; }

# Advanced customization of fzf options via _fzf_comprun function
#  - The first argument to the function is the name of the command.
#  - You should make sure to pass the rest of the arguments to fzf.
_fzf_comprun() {
    command=$1
    shift

    case "$command" in
    cd) fzf --preview "${opts_preview_dir[@]}" "$@" ;;
    export | unset) fzf --preview="eval 'echo \${}'" "$@" ;;
    ssh) fzf --preview='dig {}' "$@" ;;
    *) fzf --preview "${opts_preview_path[@]}" "$@" ;;
    esac
}

# @todo use forgit or custom completions?
#  - for git, feed it changed files
#  - https://github.com/atweiden/fzf-extras
#  - https://github.com/amaya382/zsh-fzf-widgets
#  - https://github.com/yuki-yano/zeno.zsh

# Custom fuzzy completion for git
#  - e.g. git branch **<TAB>
_fzf_complete_git() {
    # echo "got cmd $1 and args $*"
    case $1 in
    # @todo is there a convenient way to also alias these or export them as
    # methods for use with a launcher?
    *git\ branch*)
        shift
        # @todo not automatically shared with bind commands
        git_branch() {
            git branch \
                --sort=-committerdate \
                --sort=-HEAD \
                --color=always \
                --format=$'%(HEAD) %(color:yellow)%(refname:short) %(color:green)(%(committerdate:relative))\t%(color:blue)%(subject)%(color:reset)' \
                "$@" | column -t -s $'\t'
        }

        # _fzf_complete -- "$@" < <(git_branch "$@")
        git_branch "$@" | _fzf_complete \
            --prompt='Branches> ' \
            --tiebreak=begin \
            --no-hscroll \
            --color hl:underline,hl+:underline \
            --bind 'ctrl-/:change-preview-window(down,70%|hidden|)' \
            --bind "ctrl-o:execute-silent: git_branch {}" \
            --bind "alt-a:change-prompt(All branches> )+reload:git_branch -a" \
            --preview-window down,border-top,40% \
            --preview "git log \
                --oneline \
                --topo-order \
                --color=always \
                --pretty='format:%C(auto)%cd %h%d %s' \
                \$(echo {} | sed 's/^..//' | cut -d ' ' -f 1)" \
            -- "$@"
        ;;
    *) echo "no matches" ;;
    esac
}
