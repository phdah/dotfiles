#!/bin/bash

# Install Google Chrome
# wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
# sudo dpkg -i google-chrome-stable_current_amd64.deb
# rm google-chrome-stable_current_amd64.deb

# Install git manually, this is requeried to get this script lol
# clone this repo into $HOME/repos
# git clone git@github.com:phdah/linux_set_up.git

# Define source directory
(! [ "$1" ] || ! [ "$2" ]) && printf 'Incorrect input. Make sure to input\n1: user\n2: touchpad name\n\n' && xinput && exit 1
HOME=/home/$1
SOURCE_DIR=$HOME/repos

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

# Install gitgutter
! [ -d $HOME/.config/nvim/pack/airblade/start/vim-gitgutter ] && mkdir -p $HOME/.config/nvim/pack/airblade/start && git clone https://github.com/airblade/vim-gitgutter.git $HOME/.config/nvim/pack/airblade/start/vim-gitgutter
nvim -u NONE -c "helptags $HOME/.config/nvim/pack/airblade/start/vim-gitgutter/doc" -c q

# Set zsh to the default shell
chsh -s $(which zsh)

# Set zsh synbtax highligthing
! [ -d $SOURCE_DIR/zsh-syntax-highlighting ] && git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $SOURCE_DIR/zsh-syntax-highlighting

# GNOME color theme
! [ -d $SOURCE_DIR/nord-gnome-terminal ] && git clone https://github.com/arcticicestudio/nord-gnome-terminal.git $SOURCE_DIR/nord-gnome-terminal && $SOURCE_DIR/nord-gnome-terminal/src/nord.sh

# Symlink dotfiles to repo
ln -sf $SOURCE_DIR/linux_set_up/zshrc $HOME/.zshrc
ln -sf $SOURCE_DIR/linux_set_up/xprofile $HOME/.xprofile

cp $SOURCE_DIR/linux_set_up/i3status.conf $HOME/.config/i3/i3status.conf
cp $SOURCE_DIR/linux_set_up/config $HOME/.config/i3/config
cp $SOURCE_DIR/linux_set_up/vimrc $HOME/.config/nvim/init.vim

sed -i "$ a\exec xinput set-prop '$2' 'libinput Tapping Enabled' 1" .config/i3/config
sed -i "$ a\exec xinput set-prop '$2' 'libinput Natural Scrolling Enabled' 1" .config/i3/config
