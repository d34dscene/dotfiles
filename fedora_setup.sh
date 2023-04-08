#!/bin/bash

# Get distro
. /etc/os-release
DISTRO=$NAME
VARIANT=$VARIANT_ID

# No zsh = first time setup
if [[ ${DISTRO} == Fedora* && ${VARIANT} == workstation ]]; then
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

# Add flathub; Install apps only on workstation not server
if type flatpak >/dev/null; then
	flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
	if [[ ${VARIANT} == "workstation" ]]; then
		flatpak install --noninteractive flathub com.discordapp.Discord \
			com.mastermindzh.tidal-hifi tv.plex.PlexDesktop org.gnome.Geary \
			com.valvesoftware.Steam org.qbittorrent.qBittorrent org.gimp.GIMP \
			com.mattjakeman.ExtensionManager org.signal.Signal com.brave.Browser
	fi
fi
