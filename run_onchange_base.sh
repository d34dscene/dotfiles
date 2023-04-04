#!/bin/bash

# Get distro
. /etc/os-release
DISTRO=$NAME

# No zsh = first time setup
if [[ ${DISTRO} == Fedora* ]]; then
	if ! type zsh >/dev/null; then
		sudo dnf install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm -y
		sudo dnf install https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm -y
		sudo dnf install rpmfusion-free-release-tainted dnf-plugins-core -y

		sudo dnf install -y @development-tools @virtualization \
			htop zsh unar git openssl curl dnf-automatic bat exa duf procs \
			fd-find ripgrep fzf tldr ncdu wl-clipboard gnome-tweaks lm_sensors \
			libratbag-ratbagd alacritty lutris gamescope steam-devices yt-dlp \
			ulauncher dconf-editor papirus-icon-theme wireguard-tools clang \
			clang-tools-extra python3-devel kernel-devel kernel-headers zoxide \
			python3-pip age direnv

		sudo dnf copr enable agriffis/neovim-nightly
		sudo dnf install neovim python3-neovim -y
		sudo tee /etc/dnf/dnf.conf <<EOF
[main]
gpgcheck=1
installonly_limit=3
clean_requirements_on_remove=True
best=False
skip_if_unavailable=True
max_parallel_downloads=10
defaultyes=True
fastestmirror=True
deltarpm=True
EOF
	fi
fi

# Add topgrade
if ! type topgrade >/dev/null; then
	URL=$(wget -qO- 'https://api.github.com/repos/topgrade-rs/topgrade/releases/latest' | jq -r '.assets[]|select(.name | contains("x86_64-unknown-linux-gnu")).browser_download_url')
	wget -O $HOME/.local/bin/topgrade.tar.gz $URL
	tar -xzf $HOME/.local/bin/topgrade.tar.gz -C $HOME/.local/bin/
	rm $HOME/.local/bin/topgrade.tar.gz
	chmod +x $HOME/.local/bin/topgrade.tar.gz
fi

# Add wormhole
if ! type wormhole >/dev/null; then
	URL=$(wget -qO- 'https://api.github.com/repos/magic-wormhole/magic-wormhole.rs/releases/latest' | jq -r '.assets[]|select(.name=="wormhole-rs").browser_download_url')
	wget -O $HOME/.local/bin/wormhole $URL
	chmod +x $HOME/.local/bin/wormhole
fi

# Add sops
if ! type sops >/dev/null; then
	URL=$(wget -qO- 'https://api.github.com/repos/mozilla/sops/releases/latest' | jq -r '.assets[]|select(.name | contains("linux.amd64")).browser_download_url')
	wget -O $HOME/.local/bin/sops $URL
	chmod +x $HOME/.local/bin/sops
fi

# Add zsh plugin manager
if [[ -e "$HOME/.antidote" ]]; then
	git -C $HOME/.antidote pull
else
	git clone --depth=1 https://github.com/mattmc3/antidote.git ${ZDOTDIR:-~}/.antidote
fi

# Add flathub
if type flatpak >/dev/null; then
	flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
	flatpak install --noninteractive flathub com.discordapp.Discord \
		com.mastermindzh.tidal-hifi tv.plex.PlexDesktop org.gnome.Geary \
		com.valvesoftware.Steam org.qbittorrent.qBittorrent org.gimp.GIMP \
		com.mattjakeman.ExtensionManager org.signal.Signal com.brave.Browser
fi

# Add pyenv
if ! type pyenv >/dev/null; then
	curl https://pyenv.run | bash
fi

# Add poetry
if ! type poetry >/dev/null; then
	export POETRY_HOME="$HOME/.poetry"
	curl -sSL https://install.python-poetry.org | python
fi

# Add nvm
if ! type nvm >/dev/null; then
	curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | bash
	nvm install --lts
fi

# Add npm and base packages
if type npm >/dev/null; then
	npm i -g npm@latest prettier eslint_d
fi

# Add go extensions
if type go >/dev/null; then
	type staticcheck &>/dev/null || go install honnef.co/go/tools/cmd/staticcheck@latest
	type shfmt &>/dev/null || go install mvdan.cc/sh/v3/cmd/shfmt@latest
	type goimports &>/dev/null || go install golang.org/x/tools/cmd/goimports@latest
	type gomodifytags &>/dev/null || go install github.com/fatih/gomodifytags@latest
fi

# Add nerd fonts
required_fonts=(FiraCode FiraMono SourceCodePro JetBrainsMono)
mkdir -p $HOME/.local/share/fonts

missing_fonts=()
for font in ${required_fonts[@]}; do
	if [[ ! -e "$HOME/.local/share/fonts/$font" ]]; then
		missing_fonts+=($font)
	fi
done

if [[ ${#missing_fonts[@]} -gt 0 ]]; then
	git clone --filter=blob:none --sparse git@github.com:ryanoasis/nerd-fonts $HOME/nerd-fonts
	for font in ${missing_fonts[@]}; do
		git -C $HOME/nerd-fonts sparse-checkout add patched-fonts/$font
		mv $HOME/nerd-fonts/patched-fonts/$font ~/.local/share/fonts/
	done
	rm -rf $HOME/nerd-fonts
fi
