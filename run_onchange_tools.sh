#!/bin/bash

# Custom download function to get latest release
# ARGS: repository, match release name, output name
fetch() {
	URL="https://api.github.com/repos/${1}/releases/latest"
	MATCH="[.assets[] | select(.name | contains(\"${2}\")).browser_download_url][0]"
	LATEST=$(wget -qO- ${URL} | jq -r "${MATCH}")
	EXTENSION="${LATEST##*.}"

	DLPATH="${HOME}/.local/bin"
	if [[ "${EXTENSION}" == "gz" ]]; then
		wget -O ${DLPATH}/dl.tar.gz ${LATEST}
		tar -xzf ${DLPATH}/dl.tar.gz -C ${DLPATH}
		rm ${DLPATH}/dl.tar.gz
	elif [[ "${EXTENSION}" == "zip" ]]; then
		wget -O ${DLPATH}/dl.zip ${LATEST}
		unzip ${DLPATH}/dl.zip -d ${DLPATH}
		rm ${DLPATH}/dl.zip
	else
		wget -O ${DLPATH}/${3} ${LATEST}
	fi

	# Cleanup
	chmod +x ${DLPATH}/${3}
	rm -R -- */
	rm ${DLPATH}/*.md ${DLPATH}/LICENSE
}

type wormhole &>/dev/null || fetch "magic-wormhole/magic-wormhole.rs" "wormhole-rs" "wormhole"
type doggo &>/dev/null || fetch "mr-karan/doggo" "linux_amd64" "doggo"

# Add zsh plugin manager
if [[ -e "$HOME/.antidote" ]]; then
	git -C $HOME/.antidote pull
else
	git clone --depth=1 https://github.com/mattmc3/antidote.git ${ZDOTDIR:-~}/.antidote
fi

# Add pyenv
if ! type pyenv &>/dev/null; then
	curl https://pyenv.run | bash
fi

# Add nvm
if [[ ! -e "$HOME/.nvm/nvm.sh" ]]; then
	curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | bash
	nvm install --lts
fi

# Add pipx
if type python &>/dev/null; then
	type pipx &>/dev/null || python -m pip install --user pipx
	type black &>/dev/null || pipx install black
	type isort &>/dev/null || pipx install isort
fi

# Add npm and base packages
if type npm &>/dev/null; then
	type prettier &>/dev/null || npm install -g prettier
	type eslint_d &>/dev/null || npm install -g eslint_d
fi

# Add distrobox dev version
type distrobox &>/dev/null || wget -qO- https://raw.githubusercontent.com/89luca89/distrobox/main/install | sh -s -- --next --prefix ~/.local

# Add go extensions
if type go &>/dev/null; then
	type go-global-update &>/dev/null || go install github.com/Gelio/go-global-update@latest
	type staticcheck &>/dev/null || go install honnef.co/go/tools/cmd/staticcheck@latest
	type shfmt &>/dev/null || go install mvdan.cc/sh/v3/cmd/shfmt@latest
	type goimports &>/dev/null || go install golang.org/x/tools/cmd/goimports@latest
	type gomodifytags &>/dev/null || go install github.com/fatih/gomodifytags@latest
	type flarectl &>/dev/null || go install github.com/cloudflare/cloudflare-go/cmd/flarectl@latest
	type sops &>/dev/null || go install go.mozilla.org/sops/v3/cmd/sops@latest
	type duf &>/dev/null || go install github.com/muesli/duf@latest
fi

if type cargo &>/dev/null; then
	type cargo-install-update &>/dev/null || cargo install cargo-update
	type cargo-cache &>/dev/null || cargo install cargo-cache
	type topgrade &>/dev/null || cargo install topgrade
	type stylua &>/dev/null || cargo install stylua
	type procs &>/dev/null || cargo install procs
	type bat &>/dev/null || cargo install bat
	type oha &>/dev/null || cargo install oha
	type xh &>/dev/null || cargo install xh
fi
