#!/bin/bash
set -e

# Install git manually, this is requeried to get this script lol

# Define source directory
    (! [ "$1" ] ) && printf 'Incorrect input. Make sure to input\n1: user\n\n' && exit 1
    if [[ "$1" == 'CI' ]]
        then
            HOME=/home/runner/work/linux_set_up/linux_set_up
            SOURCE_DIR=$HOME
            BUILD_DIR=$SOURCE_DIR
            CONFIG=$HOME/.config
        else
            HOME=/home/$1
            SOURCE_DIR=$HOME/repos
            BUILD_DIR=$SOURCE_DIR/linux_set_up
            CONFIG=$HOME/.config
    fi

# Set up folders
printf '\nSetting up base directories\n\n'
    # Set up folders
    ! [ -d "$HOME/repos" ] && mkdir -p "$HOME/repos"
    ! [ -d $HOME/repos/work ] && mkdir -p $HOME/repos/work
    ! [ -d $HOME/repos/privat ] && mkdir -p $HOME/repos/privat
    ! [ -d $HOME/scripts ] && mkdir -p $HOME/scripts
    ! [ -d $HOME/downloads ] && mkdir -p $HOME/downloads

    ! [ -d "$CONFIG" ] && mkdir -p $CONFIG
    ! [ -d "$CONFIG/clangd" ] && mkdir -p $CONFIG/clangd

printf '\nApt installs\n\n'
if [[ "$1" != 'CI' ]]
    then
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
            snap
            # TODO:
            # fast-syntax-highlighting.plugin.zsh

    apt update --yes
    printf 'Packages not updated\n'
    apt list --upgradable
    apt autoremove --yes
    fi

# Set zsh to the default shell
if [[ "$1" != 'CI' ]]
    then
        chsh -s $(which zsh)
    fi

# Install neovim from source, unless CI mode, since it's like 10m install
if [[ "$1" != 'CI' ]]
    then
        printf '\nBuilding (stable) neovim from source\n\n'
            ! [ -d $SOURCE_DIR/neovim ] && git clone https://github.com/neovim/neovim.git $SOURCE_DIR/neovim && apt-get install ninja-build gettext libtool libtool-bin autoconf automake cmake g++ pkg-config unzip && cd neovim && git checkout stable && make CMAKE_BUILD_TYPE=RelWithDebInfo && make install
    fi

# Install gitgutter
    printf '\nSetting up gitgutter\n\n'
        ! [ -d $BUILD_DIR/nvim/pack/airblade/vim-gitgutter ] && mkdir -p $BUILD_DIR/nvim/pack/airblade/vim-gitgutter && git clone https://github.com/airblade/vim-gitgutter.git $BUILD_DIR/nvim/pack/airblade/vim-gitgutter
if [[ "$1" != 'CI' ]]
    then
        nvim -u NONE -c "helptags $BUILD_DIR/nvim/pack/airblade/vim-gitgutter/doc" -c q
    fi

# Set zsh synbtax highlighting
# TODO: substitute for fast-syntax-highlighting.plugin.zsh
printf 'Setting up zsh highlighting\n'
    ! [ -d $SOURCE_DIR/zsh-syntax-highlighting ] && git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $SOURCE_DIR/zsh-syntax-highlighting

# Install nvim packer
printf '\nSetting up nvim packer\n\n'
    ! [ -d $HOME/.local/share/nvim/site/pack/packer/start/packer.nvim ] && mkdir -p $HOME/.local/share/nvim/site/pack/packer/start/packer.nvim && git clone --depth 1 https://github.com/wbthomason/packer.nvim $HOME/.local/share/nvim/site/pack/packer/start/packer.nvim

# Symlink dotfiles to repo
printf 'Setting up symlinks\n'
    # Files
    ln -sf $BUILD_DIR/wsl_zshrc $HOME/.zshrc
    ln -sf $BUILD_DIR/gdbinit $HOME/.gdbinit
    ln -sf $BUILD_DIR/user-dirs.dirs $CONFIG/user-dirs.dirs

    # Directories
    ln -s $BUILD_DIR/nvim $CONFIG/nvim

printf 'Copying files\n'
    # Only copy over these if they don't exists
    ! [ -f "$BUILD_DIR/compile_flags.txt" ] && cp $BUILD_DIR/compile_flags.txt $CONFIG/clangd/compile_flags.txt
    ! [ -f "$HOME/.paths" ] && cp $BUILD_DIR/paths $HOME/.paths
    ! [ -f "$HOME/.envvar" ] && cp $BUILD_DIR/envvar $HOME/.envvar
    ! [ -f "$HOME/.alias" ] && cp $BUILD_DIR/alias $HOME/.alias

if [[ $1 != 'CI' ]]
    then
        clear && neofetch
fi
printf '\nDone!\n'
