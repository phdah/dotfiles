#!/bin/bash

# Install git manually, this is requeried to get this script lol

# Define source directory
    (! [ "$1" ] || ! [ "$2" ]) && printf 'Incorrect input. Make sure to input\n1: user\n2: touchpad name\n\n' && xinput && exit 1
    HOME=/home/$1
    SOURCE_DIR=$HOME/repos

# Set up folders
    # Clean up folders
printf '\nClean up and add directories\n\n'
    [ -d $HOME/Desktop ] && rm -r $HOME/Desktop
    [ -d $HOME/Documents ] && rm -r $HOME/Documents
    [ -d $HOME/Downloads ] && rm -r $HOME/Downloads
    [ -d $HOME/Music ] && rm -r $HOME/Music
    [ -d $HOME/Pictures ] && rm -r $HOME/Pictures
    [ -d $HOME/Public ] && rm -r $HOME/Public
    [ -d $HOME/Templates ] && rm -r $HOME/Templates
    [ -d $HOME/Videos ] && rm -r $HOME/Videos

    # Set up folders
    ! [ -d $HOME/repos ] && mkdir -p $HOME/repos
    ! [ -d $HOME/repos/work ] && mkdir -p $HOME/repos/work
    ! [ -d $HOME/repos/privat ] && mkdir -p $HOME/repos/privat
    ! [ -d $HOME/scripts ] && mkdir -p $HOME/scripts
    ! [ -d $HOME/downloads ] && mkdir -p $HOME/downloads

# Install packages
printf '\nParu installs\n\n'
    paru
    paru -Syy \
            i3-wm \
	    i3lock \
	    i3status \
            dmenu \
	    dunst \
            xorg-xsetroot \
            zsh \
            arandr \
            ripgrep \
            bat \
            xsel \
            maim \
            xclip \
            cmake \
            neofetch \
	    google-chrome \
            bluez \
            bluez-utils \
            pulseaudio \
            pavucontrol
    paru

# Set zsh to the default shell
chsh -s $(which zsh)

# Set up git editor
git config --global core.editor nvim
git config --global user.email phdah.sjoberg@gmail.com
git config --global user.name Philip

# Install gitgutter
printf '\nSetting up gitgutter\n\n'
    ! [ -d $HOME/.config/nvim/pack/airblade/start/vim-gitgutter ] && mkdir -p $HOME/.config/nvim/pack/airblade/start && git clone https://github.com/airblade/vim-gitgutter.git $HOME/.config/nvim/pack/airblade/start/vim-gitgutter && nvim -u NONE -c "helptags $HOME/.config/nvim/pack/airblade/start/vim-gitgutter/doc" -c q

# Set zsh synbtax highlighting
printf 'Setting up zsh highlighting\n'
    ! [ -d $SOURCE_DIR/zsh-syntax-highlighting ] && git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $SOURCE_DIR/zsh-syntax-highlighting

# GNOME color theme
printf 'Setting up Nord Gnome terminal\n'
    ! [ -d $SOURCE_DIR/nord-gnome-terminal ] && git clone https://github.com/arcticicestudio/nord-gnome-terminal.git $SOURCE_DIR/nord-gnome-terminal && $SOURCE_DIR/nord-gnome-terminal/src/nord.sh

# neovim packer
# TODO: https://github.com/wbthomason/packer.nvim

# nvim-tree
# TODO: https://github.com/nvim-tree/nvim-tree.lua

# barbar.nvim
# TODO: https://github.com/romgrk/barbar.nvim

# Symlink and copy (dot)files from repo
printf 'Setting up symlinks\n'
    ln -sf $SOURCE_DIR/linux_set_up/arch_zshrc $HOME/.zshrc
    ln -sf $SOURCE_DIR/linux_set_up/xprofile $HOME/.xprofile
    ln -sf $SOURCE_DIR/linux_set_up/gdbinit $HOME/.gdbinit
    ln -sf $SOURCE_DIR/linux_set_up/xinitrc $HOME/.xinitrc

    ln -sf $SOURCE_DIR/linux_set_up/dunstrc $HOME/.config/dunst/dunstrc
    ln -sf $SOURCE_DIR/linux_set_up/i3status.conf $HOME/.config/i3/i3status.conf
    ln -sf $SOURCE_DIR/linux_set_up/config_kitty $HOME/.config/i3/config
    ln -sf $SOURCE_DIR/linux_set_up/init.vim $HOME/.config/nvim/init.vim
    ln -sf $SOURCE_DIR/linux_set_up/user-dirs.dirs $HOME/.config/user-dirs.dirs
    ln -sf $SOURCE_DIR/linux_set_up/kitty.conf $HOME/.config/kitty/kitty.conf

    ! [ -f "$HOME/.paths" ] && cp $SOURCE_DIR/linux_set_up/paths $HOME/.paths

    cp $SOURCE_DIR/linux_set_up/scripts/* $HOME/scripts/

# Set up mousepad
    # Setting manually now
    printf 'Setting mousepad\n\n'
    xinput set-prop "$2" 'libinput Tapping Enabled' 1
    xinput set-prop "$2" 'libinput Natural Scrolling Enabled' 1
    # Making it persistant and computer unique
    cp $SOURCE_DIR/linux_set_up/i3mousepad $HOME/.i3mousepad
    echo "xinput set-prop '$1' 'libinput Tapping Enable' 1" >> $HOME/.i3mousepad
    echo "xinput set-prop '$1' 'libinput Natural Scrolling Enabled' 1" >> $HOME/.i3mousepad

clear && neofetch
printf '\nDone!\n'
