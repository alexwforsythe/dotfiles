#
# fzf-tab
#
# https://github.com/Aloxaf/fzf-tab
#

# Style

zstyle ':fzf-tab:*' fzf-pad 0
zstyle ':fzf-tab:*' fzf-min-height 30

# Sorting

# disable sort when completing options of any command
# zstyle ':completion:complete:*:options' sort false

# Disable sort when completing `git checkout`
# zstyle ':completion:*:git-checkout:*' sort false

# Key bindings

# Switch group using ctrl-p/n instead of F1/F2
zstyle ':fzf-tab:*' switch-group '^H' '^L'

# The key to accept the choice (append to fzf-bindings): 'space:enter'
zstyle ':fzf-tab:*' fzf-bindings '^A:toggle-all'

# The key to accept and enter the choice
zstyle ':fzf-tab:*' accept-line '^E'

# The key to toggle continuous reload?
# zstyle ':fzf-tab:*' continuous-trigger '^R'

# Completions

# @todo not working
# Disable fzf-tab for some commands (any|files|none)
# zstyle ':fzf-tab:complete:<forgit>:*' disabled-on any

# Preview with tree/bat by default
_fzf_preview_opts_path=${opts_preview_path[@]//'{}'/\$realpath}
zstyle ':fzf-tab:complete:*:*' fzf-preview "${_fzf_preview_opts_path[*]}"

# find out where the second one is coming from
_fzf_preview_cmd_file_pipe=${cmd_preview_file//'{}'/}
zstyle ':fzf-tab:complete:tldr:argument-1' fzf-preview "tldr --color always \$word | $_fzf_preview_cmd_file_pipe"
zstyle ':fzf-tab:complete:man:*' fzf-preview "man \$word | $_fzf_preview_cmd_file_pipe"

# Use input as query string when completing a command
# zstyle ':fzf-tab:complete:_zlua:*' query-string input
