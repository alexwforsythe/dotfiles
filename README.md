# osx
zsh

todo: configure git

homebrew
pip
node
npm
jq
ack

# fonts
https://github.com/sgolovine/PlexNerdfont


brew install screenfetch
brew install autojump

npm install -g tldr
npm install jq.node -g

git clone https://github.com/zplug/zplug $HOME/.zplug
source ~/.zplug/init.zsh
# stage plugins
zplug "zsh-users/zsh-history-substring-search"
zplug "modules/prompt", from:prezto
zplug "zsh-users/zsh-syntax-highlighting"
zplug load --verbose
zplug install

chsh -s /bin/zsh

ln -s "/Applications/Sublime Text.app/Contents/SharedSupport/bin/subl" /usr/local/bin/subl
