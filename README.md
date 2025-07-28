# dotfiles

My dotfiles for `MacOS` and `Linux`.

![platform](https://img.shields.io/badge/platform-macOS%2FLinux-blue)
![last commit](https://img.shields.io/github/last-commit/alexwforsythe/dotfiles)

- @todo add images
  - [ ] shell
  - [ ] tmux
  - [ ] vscode
  - [ ] vivaldi
- @todo manual settings
  - [ ] mac settings
  - [ ] generate ssh key and use gh cli to add (by hostname)
- @todo zsh todos
  - [ ] [tmux autostart](https://github.com/romkatv/zsh4humans/blob/master/tips.md#tmux)
  - [ ] [prompt at bottom](https://github.com/romkatv/zsh4humans/blob/master/tips.md#prompt-at-bottom)
  - [ ] [iterm2 shell integration](https://github.com/romkatv/zsh4humans/blob/master/tips.md#shell-integration)
  - [ ] [ssh teleportation](https://github.com/romkatv/zsh4humans/blob/master/tips.md#ssh)
  - [ ] [fzf tab repeat](https://github.com/romkatv/zsh4humans/blob/master/tips.md#current-directory)
  - [ ] [recursive file completions](https://github.com/romkatv/zsh4humans/blob/master/tips.md#completions)
  - [ ] [use zdotdir instead of home](https://github.com/romkatv/zsh4humans/blob/master/tips.md#alternative-zdotdir)
  - [ ] [set homebrew prefix](https://github.com/romkatv/zsh4humans/blob/master/tips.md#homebrew)
    - possible example also in zprezto modules

```shell
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false

# https://github.com/VSCodeVim/Vim#-installation
defaults write com.microsoft.VSCode ApplePressAndHoldEnabled -bool false
echo 'Enable key repeat in VSCode for VSCode Vim.'

# https://www.howtogeek.com/267463/how-to-enable-key-repeating-in-macos.
defaults write -g ApplePressAndHoldEnabled -bool false
echo 'Fast key repeat. Requires restart.'

# https://twitter.com/jordwalke/status/1230582824224165888 fast repeat.
defaults write NSGlobalDomain KeyRepeat -int 1

defaults write -g NSAutomaticWindowAnimationsEnabled -bool false
echo 'Fast opening and closing windows and popovers'

# https://robservatory.com/speed-up-your-mac-via-hidden-prefs/
defaults write NSGlobalDomain NSWindowResizeTime 0.001
echo 'Speed up dialogue boxes'
```

## Features

### MacOS

- Package manager: Homebrew
  - @todo apps
- Terminal emulator: iTerm2
  - Global hotkey window
- Window manager: yabai
  - Keyboard shortcuts: skhd
  - Status bar: spacebar
  - App switcher: AltTab
- Clipboard manager: CopyQ
- Productivity tools
  - Multitouch

### Shell

- Themes:
  - base16
  - Current: tomorrow-night-eighties-dark
- Fonts:
  - Nerd Fonts
  - Current: MesloLGS Nerd Font Mono

ZSH

- prezto
  - @todo
- Plugins:
  - prompt: Powerlevel10k
  - @todo

tmux

- Plugins:
  - statusline: lightline
  - @todo

VIM

- awesome-vimrc
- Plugins:
  - manager: vim-plug
  - @todo

Code

- nvm
- pyenv
- rvm

## Installation

Make sure the following command-line tools are installed:

- [`git`](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)
- [`curl`](https://curl.se/download.html)

Clone this repository:

```shell
mkdir -p "$HOME/.local/share"
git clone --recurse-submodules git@github.com/alexwforsythe/dotfiles "$HOME/.local/share"
```

Run the installation script:

```shell
$HOME/.local/share/dotfiles/install.sh
```

Manual steps (for now):

- SSH
  - [ ] [Generate SSH key](https://help.github.com/en/github/authenticating-to-github/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent)
- VSCode
  - [ ] [Enable key-repeating for VSCodeVim](https://github.com/VSCodeVim/Vim#mac)
- MacOS
  - iTerm2
    - [ ] Set the config directory to `$HOME/.iterm2`
    - [ ] @todo iTerm2 overwrites entire file breaking symlink

Install terminal profiles for italics support (optional):

- [guide 1](https://alexpearce.me/2014/05/italics-in-iterm2-vim-tmux/)
- [guide 2](https://medium.com/@dubistkomisch/how-to-actually-get-italics-and-true-colour-to-work-in-iterm-tmux-vim-9ebe55ebc2be)

```shell
tic -x $XDG_CONFIG_HOME/tmux/xterm-256color-italic.terminfo
tic -x $XDG_CONFIG_HOME/tmux/tmux-256color.terminfo
```

## Updating

Update this repository and all its dependencies:

```shell
git pull --recurse-submodules
```

Rerun the installation script:

```shell
./install.sh
```

## Maintenance

The following dependencies are managed under `submodules/` by this repository's
[git submodules](https://www.atlassian.com/git/tutorials/git-submodule):

- [dotbot](https://github.com/anishathalye/dotbot)
- [fonts](https://github.com/powerline/fonts)
- [prezto](https://github.com/alexwforsythe/prezto)
- [vimrc](https://github.com/alexwforsythe/vimrc)

### Updating submodules

1. Merge commits to the submodule's main branch
2. Push the main branch to the origin remote

### Updating forks

Some of the submodules are forks of popular tools like `prezto` and `vimrc`.
Occasionally, changes from the upstream repositories should be merged into the
forked repositories so that the submodules have the latest features and bug
fixes.

To pull upstream changes into a submodule:

```shell
# pull the latest changes from the forked repository
git submodule update --init --recursive
cd submodules/$submodule_dir
# pull the latest upstream changes
git pull --rebase $upstream_remote master
# resolve merge conflicts . . .
git push origin
```

## Plugins

Various tools and plugins are loaded by the following files:

- zsh: `submodules/prezto/runcoms/zpreztorc`
- vim: `vim/.vimrc`
- npm: `npm/package.json`
- Homebrew (OS X): `brew/Brewfile`

## tmux

which-key uses a VSCode dropdown menu API to display options and reads user
choices via the text input. I'm not sure why they chose that approach, but it
seems related to the fact that VSCode doesn't support nested modes. Either way,
I like that they were able to almost completely avoid messing with keybindings
because it basically sandboxes their plugin.

Maybe that has more value for plugins in complex UI apps--like IDEs and
browsers--but it got me thinking about a similar approach with tmux. Here's an
example of how you could read an input character from a popup so it closes
automatically:

```tmux
popup -E 'read -p "Enter any char: " -n 1 char; tmux display "You entered: $char"'
```

- Instead of `tmux display`, the second command could execute a bash func that
  looks up the choice's associated tmux command and executes it.
- It might be a little slower than tmux keybindings due to spawning a new shell
  process, but it still felt pretty fast to me.
- It would be easy to add an optional delay for people who don't like to see the
  popup right away by adding `sleep "$DELAY"` before `read`

Just thought I'd share the idea in case you're interested :)

## Fonts

- Nerd Font
  - [Cheat sheet](https://www.nerdfonts.com/cheat-sheet)

## Colors

scheme: "Tomorrow Night Eighties"

| code   | ansi name    | color   | description                                                                |
| ------ | ------------ | ------- | -------------------------------------------------------------------------- |
| base00 | black        | #2d2d2d | Default Background (, Cursor text)                                         |
| base01 | name         | #393939 | Lighter Background (Used for status bars, line number and folding marks)   |
| base02 | name         | #515151 | Selection Background                                                       |
| base03 | bright-black | #999999 | Comments, Invisibles, Line Highlighting                                    |
| base04 | name         | #b4b7b4 | Dark Foreground (Used for status bars)                                     |
| base05 | white        | #cccccc | Default Foreground, Caret, Delimiters, Operators (, Selected text, Cursor) |
| base06 | name         | #e0e0e0 | Light Foreground (Not often used)                                          |
| base07 | bright-white | #ffffff | Light Background (Not often used)                                          |
| base08 | red          | #f2777a | Variables, XML Tags, Markup Link Text, Markup Lists, Diff Deleted          |
| base09 | n/a          | #f99157 | Integers, Boolean, Constants, XML Attributes, Markup Link Url              |
| base0A | yellow       | #ffcc66 | Classes, Markup Bold, Search Text Background                               |
| base0B | green        | #99cc99 | Strings, Inherited Class, Markup Code, Diff Inserted                       |
| base0C | cyan         | #66cccc | Support, Regular Expressions, Escape Characters, Markup Quotes             |
| base0D | blue         | #6699cc | Functions, Methods, Attribute IDs, Headings                                |
| base0E | magenta      | #cc99cc | Keywords, Storage, Selector, Markup Italic, Diff Changed                   |
| base0F | name         | #a3685a | Deprecated, Opening/Closing Embedded Language Tags, e.g. `<?php ?>`        |

---

## Resources

### Dotfiles

Beginners

- [GitHub does dotfiles](https://dotfiles.github.io)
- [macOS Setup Guide](https://sourabhbajaj.com/mac-setup/)

Dotbot

- [Managing Your Dotfiles](https://www.anishathalye.com/2014/08/03/managing-your-dotfiles/)

Alternatives

- [General-purpose dotfiles utilities](https://dotfiles.github.io/utilities/)
- [Dotfiles: Best Way to Store in a Bare Git Repository](https://www.atlassian.com/git/tutorials/dotfiles)
  (by Atlassian)

Startup files

- [Shell Startup Scripts](https://blog.flowblok.id.au/2013-02/shell-startup-scripts.html)

### Plugins

VIM

- [vim-plug](https://github.com/junegunn/vim-plug)
- [Automatic Installation](https://github.com/junegunn/vim-plug/wiki/tips#automatic-installation)

Zsh

- [prezto](https://github.com/sorin-ionescu/prezto)
- [zsh-nvm](https://github.com/lukechilds/zsh-nvm/)

### Zsh

General

- [archlinux - Zsh](https://wiki.archlinux.org/title/zsh)
- [mastering-zsh](https://github.com/rothgar/mastering-zsh)
- [Configuring Zsh Without Dependencies](https://thevaluable.dev/zsh-install-configure-mouseless/)
- [A User's Guide to the Z-Shell](https://zsh.sourceforge.io/Guide/zshguide.html)

Completions

- [A Guide to the Zsh Completion with Examples](https://thevaluable.dev/zsh-completion-guide-examples/)
- [Writing zsh completions for CLIs with subcommands](https://www.dolthub.com/blog/2021-11-15-zsh-completions-with-subcommands/)

### Keyboard

- [Caret notation](https://en.wikipedia.org/wiki/Caret_notation)
- [C0 and C1 control codes](https://en.wikipedia.org/wiki/C0_and_C1_control_codes)
- [Common terminfo capabilities](https://wiki.archlinux.org/title/Bash/Prompt_customization#Common_capabilities)

## [Inspiration](https://dotfiles.github.io/inspiration/)

- [@samoshkin's dotfiles](https://github.com/samoshkin/dotfiles)
- [Awesome dotfiles](https://github.com/webpro/awesome-dotfiles)
