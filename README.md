# @alexwforsythe's dotfiles

(for OS X and Linux)

## Installation

Make sure the following command-line tools are installed:

- [`git`](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)
- [`curl`](https://curl.se/download.html)

Clone this repository:

```
mkdir ~/.config && cd ~/.config
git clone --recurse-submodules git@github.com/alexwforsythe/dotfiles
```

Run the installation script:

```
cd dotfiles
./install.sh
```

Manual Steps (for now):

- SSH
  - [ ] [Generate SSH key](https://help.github.com/en/github/authenticating-to-github/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent)
- VIM
  - [ ] Open `vim` to install configured plugins (`vim-plug` will take care of this upon first startup)
- Sublime Text
  - [ ] Add license
  - [ ] Install Package Control: https://packagecontrol.io/installation
  - [ ] Restart Sublime Text to install configured plugins
- VSCode
  - [ ] Sync config: https://github.com/shanalikhan/code-settings-sync/wiki/Setup-Guide
  - [ ] Install `code` command in path: https://code.visualstudio.com/docs/setup/mac#_launching-from-the-command-line
- ITerm2 (OS X)
  - [ ] Set config directory to `$HOME/.iterm2`

## Updating

Update this repository and all of its dependencies:

```
git pull --recurse-submodules
```

Rerun the installation script:

```
./install.sh
```

## Contributing

The following dependencies are managed under `modules/` by this repository's [git submodules](https://www.atlassian.com/git/tutorials/git-submodule).

- https://github.com/anishathalye/dotbot
- https://github.com/powerline/fonts
- https://github.com/alexwforsythe/prezto
- https://github.com/alexwforsythe/vimrc

### Updating submodules

- Merge commits to the submodule repository's main branch

If the submodule is a fork:

- Push the main branch to the origin remote

Otherwise:

- Open a pull request to merge changes into the upstream remote

### Updating forks

Some of the submodules are forks of popular tools such as `prezto` and `vimrc`. Occasionally, changes from the upstream repositories should be merged into the forked repositories so that the submodules have the latest features and bug fixes.

To pull upstream changes into any of these submodules:

```
# pull the latest changes from the forked repository first
git submodule update --init --recursive
cd modules/${submodule_dir}
# create a merge commit with the latest upstream changes
git pull --rebase=false ${upstream_remote} master
# resolve merge conflicts . . .
# push upstream changes to the forked repository
git push origin master
```

## Plugins

Various tools and plugins are loaded in the following files:

- zsh: `modules/prezto/runcoms/zpreztorc`
- vim: `vim/.vimrc`
- npm: `npm/package.json`
- Homebrew (OS X): `brew/Brewfile`

---

## Resources

- Dotfiles
  - dotbot: https://www.anishathalye.com/2014/08/03/managing-your-dotfiles/
  - git bare alternative: https://www.atlassian.com/git/tutorials/dotfiles
- ZSH
  - prezto: https://github.com/sorin-ionescu/prezto
  - zsh-nvm: https://github.com/lukechilds/zsh-nvm/
- VIM
  - https://github.com/junegunn/vim-plug
  - https://github.com/junegunn/vim-plug/wiki/tips#automatic-installation
- OS X
  - https://sourabhbajaj.com/mac-setup/
