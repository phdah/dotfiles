#!/bin/bash

# Install Google Chrome
# wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
# sudo dpkg -i google-chrome-stable_current_amd64.deb
# rm google-chrome-stable_current_amd64.deb

# Install git manually, this is requeried to get this script lol
# clone this repo into $HOME/repos
# git clone git@github.com:phdah/linux_set_up.git

# Define source directory
HOME=/home/$1
SOURCE_DIR=$HOME/repos/linux_set_up

# Clean up folders
[ -d $HOME/Desktop ] && rm -r $HOME/Desktop
[ -d $HOME/Documents ] && rm -r $HOME/Documents
[ -d $HOME/Downloads ] && rm -r $HOME/Downloads
[ -d $HOME/Music ] && rm -r $HOME/Music
[ -d $HOME/Pictures ] && rm -r $HOME/Pictures
[ -d $HOME/Public ] && rm -r $HOME/Public
[ -d $HOME/Templates ] && rm -r $HOME/Templates
[ -d $HOME/Videos ] && rm -r $HOME/Videos

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
	neovim \
        ripgrep \
        bat

apt update --yes

# Set zsh to the default shell
chsh -s $(which zsh)

# Set zsh synbtax highligthing
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $SOURCE_DIR

# GNOME color theme
git clone https://github.com/arcticicestudio/nord-gnome-terminal.git $SOURCE_DIR
./$SOURCE_DIR/nord-gnome-terminal/src/nord.sh

# Symlink dotfiles to repo
ln -s $SOURCE_DIR/zshrc $HOME/.zshrc
ln -s $SOURCE_DIR/i3status.conf $HOME/.config/i3/i3status.conf
ln -s $SOURCE_DIR/config $HOME/.config/i3/config

# Create nvim is not exists
[ -d $HOME/.config/nvim ] && mkdir -p $HOME/.config/nvim
ln -s $SOURCE_DIR/vimrc $HOME/.config/nvim/init.vim
