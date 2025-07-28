#!/usr/bin/env bash

#
# forgit
#
# https://github.com/wfxr/forgit
#

forgit_dir=$XDG_DATA_HOME/shell-plugins/forgit
plugin="$forgit_dir/forgit.plugin.sh"
# @todo zsh or sh, conditionally
plugin="$forgit_dir/forgit.plugin.zsh"
if [[ ! -r $plugin ]]; then
    log:warn "file not found: $plugin"
    return 1
fi

# Defined aliases, overriding ones set by the prezto git plugin (so we don't
# have to remember more).

export forgit_log=gl
export forgit_diff=gwd
export forgit_add=gia
export forgit_reset_head=giR
export forgit_ignore=gi
export forgit_checkout_file=gco
export forgit_checkout_branch=gcb # @todo
export forgit_branch_delete=gbx
export forgit_checkout_tag=gct    # @todo
export forgit_checkout_commit=gco # @todo
export forgit_revert_commit=grc   # @todo
export forgit_clean=gclean        # @todo
export forgit_stash_show=gsd
export forgit_stash_push=gs
export forgit_cherry_pick=gcp
export forgit_rebase=gri
export forgit_blame=gbl # @todo
export forgit_fixup=gfu # @todo

# Load the plugin.
if ! source:file "$plugin"; then
    return 1
fi

# Used by shell RCs for completion.
export FORGIT_INSTALL_DIR=$forgit_dir

# Export this after sourcing the plugin.
export PATH=$PATH:$FORGIT_INSTALL_DIR/bin

# Register completion with git
# @todo replace with compdef file
# zstyle ':completion:*:*:git:*' user-commands forgit:'description for foo'

# @todo need completions!! should make fzf-tab invoke forgit functions, too
# after `forgit` was loaded
