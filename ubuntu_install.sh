#!/bin/bash

# Define source directory
HOME=/home/$1
SOURCE_DIR=$HOME/repos/linux_set_up

# Clean up folders
rm -r $HOME/Desktop $HOME/Documents $HOME/Downloads $HOME/Music $HOME/Pictures $HOME/Public $HOME/Templates $HOME/Videos

# Set up folders
[ -d $HOME/repos ] || mkdir -p $HOME/repos
[ -d $HOME/scripts ] || mkdir -p $HOME/scripts
[ -d $HOME/downloads ] || mkdir -p $HOME/downloads

# Install Google Chrome
# wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
# sudo dpkg -i google-chrome-stable_current_amd64.deb
# rm google-chrome-stable_current_amd64.deb

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
echo "NOT DOING symlink to $SOURCE_DIR/zshrc"
ln -s $SOURCE_DIR/zshrc $HOME/.zshrc

# Create nvim is not exists
if ! [[ -d $HOME/.config/nvim ]]
then mkdir -p $HOME/.config/nvim
fi
ln -s $SOURCE_DIR/vimrc $HOME/.config/nvim/init.vim
