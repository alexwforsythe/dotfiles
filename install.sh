#!/usr/bin/env sh

set -e

#
# install:
#
# Installs (or updates) all dotfiles using dotbot:
#   - Files in config/ are symlinked to $HOME
#   - Files & directories in apps/ are symlinked to their respective locations
# packages are installed via curl, brew, apt, npm, tmux, vim
#
# @todo switch for which config(s), default to all
#

script_dir=$(dirname "$(readlink -f "$0")")
dotbot_dir="$script_dir/submodules/dotbot"
dotbot="$dotbot_dir/bin/dotbot"

cfg_file="install.conf.yaml"

# Update dotbot.
git -C "$dotbot_dir" submodule sync --quiet --recursive
git -C "$dotbot_dir" submodule update --init --recursive

# Bootstrap dotfiles.
"$dotbot" \
    --verbose \
    --base-directory "$script_dir" \
    --plugin-dir dotbot-brew \
    --config-file "$cfg_file" \
    "$@"

setopt EXTENDED_GLOB
dotfiles_dir=${XDG_DATA_HOME:-$HOME/.local/share}/dotfiles
# shellcheck disable=1036,1058,1072,1073
for rcfile in "$dotfiles_dir"/configs/^README.md(.N); do
  ln -s "$rcfile" "$dotfiles_dir/configs/.${rcfile:t}"
done
unset dotfiles_dir
