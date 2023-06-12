#!/bin/bash

# Install git manually, this is requeried to get this script lol

# Define source directory
    (! [ "$1" ] ) && printf 'Incorrect input. Make sure to input\n1: user\n\n' && exit 1
    if [[ $1 == 'CI' ]];
        then
            HOME=${GITHUB_WORKSPACE}
        else
            HOME=/home/$1
    fi
    SOURCE_DIR=$HOME/repos

# Set up folders
printf '\nSetting up base directories\n\n'
    # Set up folders
    ! [ -d $HOME/repos ] && mkdir -p $HOME/repos
    ! [ -d $HOME/repos/work ] && mkdir -p $HOME/repos/work
    ! [ -d $HOME/repos/privat ] && mkdir -p $HOME/repos/privat
    ! [ -d $HOME/scripts ] && mkdir -p $HOME/scripts
    ! [ -d $HOME/downloads ] && mkdir -p $HOME/downloads

printf '\nApt installs\n\n'
    apt upgrade --yes
    apt update --yes
    apt install --yes \
            zsh \
            curl \
            bat \
            ripgrep \
            xsel \
            maim \
            xclip \
            fzf \
            gdb \
            neofetch \
            neovim
            # TODO:
            # fast-syntax-highlighting.plugin.zsh

    apt update --yes
    printf 'Packages not updated\n'
    apt list --upgradable
    apt autoremove --yes

# Set zsh to the default shell
chsh -s $(which zsh)

# Install gitgutter
printf '\nSetting up gitgutter\n\n'
    ! [ -d $HOME/.config/nvim/pack/airblade/start/vim-gitgutter ] && mkdir -p $HOME/.config/nvim/pack/airblade/start && git clone https://github.com/airblade/vim-gitgutter.git $HOME/.config/nvim/pack/airblade/start/vim-gitgutter && nvim -u NONE -c "helptags $HOME/.config/nvim/pack/airblade/start/vim-gitgutter/doc" -c q

# Set zsh synbtax highlighting
# TODO: substitute for fast-syntax-highlighting.plugin.zsh
printf 'Setting up zsh highlighting\n'
    ! [ -d $SOURCE_DIR/zsh-syntax-highlighting ] && git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $SOURCE_DIR/zsh-syntax-highlighting

# Install nvim packer
printf '\nSetting up nvim packer\n\n'
    ! [ -d $HOME/.local/share/nvim/site/pack/packer/start/packer.nvim ] && mkdir -p $HOME/.local/share/nvim/site/pack/packer/start/packer.nvim && git clone --depth 1 https://github.com/wbthomason/packer.nvim $HOME/.local/share/nvim/site/pack/packer/start/packer.nvim

# Symlink dotfiles to repo
printf 'Setting up symlinks\n'
    ln -sf $SOURCE_DIR/linux_set_up/wsl_zshrc $HOME/.zshrc
    ln -sf $SOURCE_DIR/linux_set_up/gdbinit $HOME/.gdbinit

    ln -sf $SOURCE_DIR/linux_set_up/init.vim $HOME/.config/nvim/init.vim
    ln -sf $SOURCE_DIR/linux_set_up/user-dirs.dirs $HOME/.config/user-dirs.dirs
    ln -sf $SOURCE_DIR/linux_set_up/wsl_plugins.lua $HOME/.config/nvim/lua/plugins.lua

    ! [ -f "$HOME/.paths" ] && cp $SOURCE_DIR/linux_set_up/paths $HOME/.paths
    ! [ -f "$HOME/.envvar" ] && cp $SOURCE_DIR/linux_set_up/envvar $HOME/.envvar
    ! [ -f "$HOME/.alias" ] && cp $SOURCE_DIR/linux_set_up/alias $HOME/.alias

clear && neofetch
printf '\nDone!\n'
