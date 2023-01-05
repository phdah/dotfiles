#!/bin/bash

# Clean up folders
rm -r Desktop Documents Downloads Music Pictures Public Templates Videos

# Set up folders
mkdir stuff scripts downloads

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
