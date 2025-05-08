#!/bin/bash

curl -LO https://github.com/neovim/neovim/releases/download/nightly/nvim-linux-x86_64.tar.gz
tar xzf nvim-linux-x86_64.tar.gz

./nvim-linux-x86_64/bin/nvim --version

git clone https://github.com/phdah/dotfiles.git "$HOME"/dotfiles
ln -s /root/dotfiles/nvim "$HOME"/.config/nvim
