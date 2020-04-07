# @alexwforsythe's dotfiles
(for OS X and Linux)

## Installation

Clone this repository:
```
mkdir ~/.config && cd ~/.config
git clone git@github.com/alexwforsythe/dotfiles
```

Run the installation script:
```
cd dotfiles
./install.sh
```

Manual Steps (for now):
* SSH
    [ ] Generate SSH Key: https://help.github.com/en/github/authenticating-to-github/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent
* VIM
    [ ] Open `vim` and install configured plugins
* Sublime Text
    [ ] Add license
    [ ] Install Package Control: https://packagecontrol.io/installation
    [ ] Restart Sublime Text to install configured plugins
* VSCode
    [ ] Sync config: https://github.com/shanalikhan/code-settings-sync/wiki/Setup-Guide
    [ ] Install `code` command in path: https://code.visualstudio.com/docs/setup/mac#_launching-from-the-command-line
ITerm2 (OS X)
    [ ] Set config directory to `$HOME/.iterm2`

## Dependencies

* `git`
* `curl`

The following dependencies are managed under `modules/` by this repository's [git subtree](https://www.atlassian.com/git/tutorials/git-subtree).

* https://github.com/anishathalye/dotbot
* https://github.com/powerline/fonts
* https://github.com/alexwforsythe/prezto
* https://github.com/alexwforsythe/vimrc

Various tools and plugins are loaded in the following files:
* zsh: `modules/prezto/runcoms/zpreztorc`
* vim: `vim/.vimrc`
* npm: `npm/package.json`
* Homebrew (OS X): `brew/Brewfile`

---

## Resources

* Dotfiles
    - dotbot: https://www.anishathalye.com/2014/08/03/managing-your-dotfiles/
    - git bare alternative: https://www.atlassian.com/git/tutorials/dotfiles
* ZSH
    - prezto: https://github.com/sorin-ionescu/prezto
    - zsh-nvm: https://github.com/lukechilds/zsh-nvm/
* VIM
    - https://github.com/junegunn/vim-plug
      - https://github.com/junegunn/vim-plug/wiki/tips#automatic-installation
* OS X
    - https://sourabhbajaj.com/mac-setup/