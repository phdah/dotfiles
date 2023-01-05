#!/bin/bash

# Define source directory
SOURCE_DIR=$HOME/repos

# Clean up folders
rm -r $HOME/Desktop $HOME/Documents $HOME/Downloads $HOME/Music $HOME/Pictures $HOME/Public $HOME/Templates $HOME/Videos

# Set up folders
mkdir stuff scripts downloads
# Create repos is not exists
if ! [[ -d $SOURCE_DIR ]]
then mkdir -p $SOURCE_DIR
fi

# Install Google Chrome
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo dpkg -i google-chrome-stable_current_amd64.deb
rm google-chrome-stable_current_amd64.deb

# Install packages
## install git manually, this is requeried to get this script lol
apt upgrade --yes
apt update --yes

apt install --yes \
	i3 \
	zsh \
	arandr \
	curl \
	neovim

apt update --yes

# Set zsh to the default shell
chsh -s $(which zsh)

# Set zsh synbtax highligthing
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $SOURCE_DIR

# Symlink dotfiles to repo
ln -s $SOURCE_DIR/zshrc $HOME/.zshrc

# Create nvim is not exists
if ! [[ -d $HOME/.config/nvim ]]
then mkdir -p $HOME/.config/nvim
fi
ln -s $SOURCE_DIR/vimrc $HOME/.config/nvim/init.vim
