USR ?= $(USER)

ifeq ($(USR),)
$(error Incorrect input. Make sure to input user.)
endif

ifeq ($(USR),CI)
HOME=/home/runner/work/linux_set_up/linux_set_up
SOURCE_DIR=$(HOME)
BUILD_DIR=$(SOURCE_DIR)
CONFIG=$(HOME)/.config
else
HOME=/home/$(USR)
SOURCE_DIR=$(HOME)/repos
BUILD_DIR=$(SOURCE_DIR)/linux_set_up
CONFIG=$(HOME)/.config
endif

args: ## Print all args
	@echo "HOME=$(HOME)"
	@echo "SOURCE_DIR=$(SOURCE_DIR)"
	@echo "BUILD_DIR=$(BUILD_DIR)"
	@echo "CONFIG=$(CONFIG)"

i3-args: ## Check mousepad name
	@/bin/bash -c '\
		printf "Setting mousepad\n\n"; \
		xinput; \
		echo -n "- enter the value of the mousepad from the above output: "; \
		read answer; \
		xinput set-prop "$$answer" "libinput Tapping Enabled" 1; \
		xinput set-prop "$$answer" "libinput Natural Scrolling Enabled" 1'
		# Making it persistent and computer unique; \
		cp "$(BUILD_DIR)"/i3mousepad "$(HOME)"/.i3mousepad
		printf 'Add these two lines to ~/.i3mousepad\n'
		echo "xinput set-prop 'NAME_OF_MOUSE_PAD' 'libinput Tapping Enable' 1"
		echo "xinput set-prop 'NAME_OF_MOUSE_PAD' 'libinput Natural Scrolling Enabled' 1"

os-check: ## Check what OS is installed
	@uname -a

base-dir: ## Setup base directories
	@printf '\nSetting up base directories\n\n'
	@mkdir -p $(HOME)/repos $(HOME)/repos/work $(HOME)/repos/privat $(HOME)/scripts $(HOME)/downloads $(CONFIG) $(CONFIG)/clangd

base-apt-pkr: ## Install packages for base Ubuntu, e.g., WSL
	@printf '\nApt installs\n\n'
	@if [ "$(USR)" != "CI" ]; then \
		sudo apt upgrade --yes; \
		sudo apt update --yes; \
		sudo apt install --yes \
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
			snap \
			; \
		sudo apt update --yes; \
		printf 'Packages not updated\n'; \
		sudo apt list --upgradable; \
		sudo apt autoremove --yes; \
	fi

ubuntu-pkr: ## Install packages for Ubuntu
	@printf '\nApt installs\n\n'
	@if [ "$(USR)" != "CI" ]; then \
		sudo apt upgrade --yes; \
		sudo apt update --yes; \
		sudo apt install --yes \
			i3 \ # Window manger
			zsh \ # Shell
			arandr \ # Monitor ctl
			dunst \ # Notifications
			pulseaudio \ # Sound software used by pavucontrol
			pavucontrol \ # Sound and mic controller
			brightnessctl # Light controller
			; \
		sudo apt update --yes; \
		printf 'Packages not updated\n'; \
		sudo apt list --upgradable; \
		sudo apt autoremove --yes; \
	fi

arch-pkr: ## Install packges for arch
	@# Install packages
	@printf '\nParu installs\n\n'
		@paru
		@paru -Syy \
			i3-wm \ # Window manager
			i3lock \ # Lock screen
			i3status \ # Status bar
			dmenu \ # Application meny
			dunst \ # Notifications
			xorg-xsetroot \ # X
			zsh \ # Shell
			zsh-vi-mode.plugin.zsh \ # zsh terminal vim mode
			fast-syntax-highlighting.plugin.zsh \ # zsh terminal highlighting
			arandr \ # Monitor ctl
			ripgrep \ # A better grep
			bat \ # A better cat
			xsel \ # Allow to copy
			maim \ # Allow to screen snippet
			xclip \ # Allo to screen snippet
			cmake \ # Make for c
			fzf \ # Fuzzy finder
			neofetch \ # Display os info
			gdb \ # Debugger
			google-chrome \ # Web browser
			bluez \ # Bluethooth
			bluez-utils \ # Bluethooth, use bluetoothctl
			pulseaudio \ # Sound software used by pavucontrol
			pavucontrol \ # Sound and mic controller
			brightnessctl \ # Light controller
		@paru


google-chrome: ## Install Google Chrome from source
	# Install Google Chrome
	@if [ "$(USR)" != "CI" ]; then \
		printf '\nInstall Google chrome\n\n'; \
		wget -P $(HOME) https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb; \
		dpkg -i $(HOME)/google-chrome-stable_current_amd64.deb; \
		sudo apt-get install -f --yes; \
		printf 'Removing files\n\n'; \
		rm $(HOME)/google-chrome-stable_current_amd64.deb; \
	fi

zsh-shell: ## Set zsh as the shell
	@if [ "$(USR)" != "CI" ]; then \
		sudo chsh -s $$(which zsh); \
	fi

nvim-install: ## Install neovim from source, unless CI mode, since it's like 10m install
	@if [ "$(USR)" != "CI" ]; then \
		printf '\nBuilding (stable) neovim from source\n\n'; \
		if [ ! -d $(SOURCE_DIR)/neovim ]; then \
			git clone https://github.com/neovim/neovim.git $(SOURCE_DIR)/neovim; \
			# sudo apt-get install ninja-build gettext libtool libtool-bin autoconf automake cmake g++ pkg-config unzip; \
			cd $(SOURCE_DIR)/neovim && git checkout stable && make CMAKE_BUILD_TYPE=RelWithDebInfo && sudo make install && cd $(BUILD_DIR); \
		fi \
	fi

gitgutter-install: ## Install gitgutter
	@printf '\nSetting up gitgutter\n\n'
	@if [ ! -d $(BUILD_DIR)/nvim/pack/airblade/start/vim-gitgutter ]; then \
		mkdir -p $(BUILD_DIR)/nvim/pack/airblade/start/vim-gitgutter; \
		git clone https://github.com/airblade/vim-gitgutter.git $(BUILD_DIR)/nvim/pack/airblade/start/vim-gitgutter; \
	fi
	@if [ "$(USR)" != "CI" ]; then \
		printf 'Installing gitgutter\n'; \
		nvim -u NONE -c "helptags $(BUILD_DIR)/nvim/pack/airblade/start/vim-gitgutter/doc" -c q; \
	fi

zshhl-install: ## Set zsh syntax highlighting
	@printf 'Setting up zsh highlighting\n'
	@if [ ! -d $(SOURCE_DIR)/zsh-syntax-highlighting ]; then \
		git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $(SOURCE_DIR)/zsh-syntax-highlighting; \
	fi

packer-install: ## Install nvim packer
	@printf '\nSetting up nvim packer\n\n'
	@if [ ! -d $(HOME)/.local/share/nvim/site/pack/packer/start/packer.nvim ]; then \
		mkdir -p $(HOME)/.local/share/nvim/site/pack/packer/start/packer.nvim; \
		git clone --depth 1 https://github.com/wbthomason/packer.nvim $(HOME)/.local/share/nvim/site/pack/packer/start/packer.nvim; \
	fi

gnome-nord: ## Install Nord colors for Gnome
# GNOME color theme
	@printf 'Setting up Nord Gnome terminal\n'
	@! [ -d $(SOURCE_DIR)/nord-gnome-terminal ] && git clone https://github.com/arcticicestudio/nord-gnome-terminal.git $(SOURCE_DIR)/nord-gnome-terminal && $(SOURCE_DIR)/nord-gnome-terminal/src/nord.sh

base-symlink: ## Symlink dotfiles to repo
	@printf 'Setting up symlinks\n'
	@ln -sf $(BUILD_DIR)/gdbinit $(HOME)/.gdbinit
	@ln -sf $(BUILD_DIR)/user-dirs.dirs $(CONFIG)/user-dirs.dirs
	@ln -sf $(BUILD_DIR)/nvim $(CONFIG)

wsl-symlink: ## Symlink dotfiles to repo
	@printf 'Setting up symlinks for wsl\n'
	@ln -sf $(BUILD_DIR)/wsl_zshrc $(HOME)/.zshrc

ubuntu-symlink: ## Symlink dotfiles to repo
	@printf 'Setting up symlinks for wsl\n'
	@ln -sf $(BUILD_DIR)/ubuntu_zshrc $(HOME)/.zshrc

arch-symlink: ## Symlink for arch
	@printf 'Setting up symlinks for arch\n'
	@ln -sf $(BUILD_DIR)/arch_zshrc $(HOME)/.zshrc
	@ln -sf $(BUILD_DIR)/xprofile $(HOME)/.xprofile
	@ln -sf $(BUILD_DIR)/xinitrc $(HOME)/.xinitrc
	@ln -sf $(BUILD_DIR)/zprofile $(HOME)/.zprofile

	@ln -sf $(BUILD_DIR)/dunstrc $(CONFIG)/dunst/dunstrc
	@ln -sf $(BUILD_DIR)/i3status.conf $(CONFIG)/i3/i3status.conf
	@ln -sf $(BUILD_DIR)/i3config $(CONFIG)/i3/config
	@ln -sf $(BUILD_DIR)/kitty.conf $(CONFIG)/kitty/kitty.conf

copy-dirs: ## Copy files and dirs
	@printf 'Copying files\n'
	# @if [ ! -f "$(BUILD_DIR)/compile_flags.txt" ]; then cp $(BUILD_DIR)/compile_flags.txt $(CONFIG)/clangd/compile_flags.txt; fi
	@if [ ! -f "$(HOME)/.paths" ]; then cp $(BUILD_DIR)/paths $(HOME)/.paths; fi
	@if [ ! -f "$(HOME)/.envvar" ]; then cp $(BUILD_DIR)/envvar $(HOME)/.envvar; fi
	@if [ ! -f "$(HOME)/.alias" ]; then cp $(BUILD_DIR)/alias $(HOME)/.alias; fi

finish: ## Finish the install
	@if [ "$(USR)" != "CI" ]; then \
		clear && neofetch; \
	fi
	@printf '\nDone!\n'

wsl-install: args os-check base-dir base-apt-pkr zsh-shell nvim-install gitgutter-install zshhl-install packer-install base-symlink wsl-symlink copy-dirs finish
	@echo "WSL install done"

arch-install: args i3-args os-check base-dir arch-pkr zsh-shell nvim-install gitgutter-install packer-install base-symlink arch-symlink copy-dirs finish
	@echo "Arch install done"

ubuntu-install: args i3-args os-check base-dir base-apt-pkr ubuntu-pkr google-chrome zsh-shell nvim-install gitgutter-install zshhl-install packer-install gnome-nord base-symlink ubuntu-symlink copy-dirs finish
	@echo "Ubuntu install done"
