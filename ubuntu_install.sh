#!/bin/bash

# Install Google Chrome
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo dpkg -i google-chrome-stable_current_amd64.deb
rm google-chrome-stable_current_amd64.deb

# Install packages
apt upgrade --yes
apt update --yes

apt install --yes \
	i3 \
	zsh \
	git \
	arandr \
	curl \
	neovim

apt update --yes
	
