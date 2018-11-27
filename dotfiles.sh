#!/bin/bash

set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
BACKUP_DIR="$DIR/backup"

install_dotfiles () {
  for src in $(find $DIR -mindepth 2 -maxdepth 2 \
      -not -path "$BACKUP_DIR/*" \
      -not -path "$DIR/.*")
  do
    dst="$HOME/$(basename $src)"
    link_item "$src" "$dst"
  done
}

# Link a file or directory to the home directory.
link_item () {
  local src=$1 dst=$2
  local backup=false
  local skip=false

  if [ -L "$dst" ] ; then
    local link_src="$(readlink $dst)"

    if [ "$link_src" == "$src" ] ; then
      echo "$dst: Link already exists, skipping."
      skip=true
    else
      read -p "$dst: Link exists but is bad, remove? [Y/n] " reply
      if [[ $reply =~ [yY](es)? ]] ; then
        echo -n "$dst: Removing bad link ... "
        rm $dst ; echo 'done'
      else
        backup=true
      fi
    fi
  elif [ -f "$dst" -o -d "$dst" ] ; then
    backup=true
  fi

  if [ "$backup" == "true" ] ; then
    echo -n "$dst: Already exists, backing up ... "
    mv $dst $BACKUP_DIR ; echo 'done'
  fi

  if [ "$skip" == "false" ] ; then
    echo -n "Linking $src ... "
    ln -s "$src" "$HOME" ; echo 'done'
  fi
}

# Create backup directory
if [ ! -d $BACKUP_DIR ] ; then
  echo -n "Creating backup directory at $BACKUP_DIR for existing dotfiles ... "
  mkdir $BACKUP_DIR ; echo 'done'
fi

# Change to dotfiles directory
echo -n "Changing to $DIR directory ... "
cd $DIR ; echo 'done'

# Install the dotfiles
echo -e 'Installing dotfiles ...\n'
install_dotfiles
echo -e '\nInstallation complete.'
