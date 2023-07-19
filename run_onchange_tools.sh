#!/bin/bash

# Helper for checking if binary is available
check() {
	command -v "$1" >/dev/null 2>&1
}

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

py_tools=(
	black
	isort
)

node_tools=(
	prettier
	eslint_d
)

rust_tools=(
	cargo-update
	cargo-cache
	topgrade
	rustscan
	stylua
	procs
	bat
	oha
	xh
)

if check "pip"; then
	for tool in ${py_tools[@]}; do
		pip install $tool
	done
fi

if check "npm"; then
	for tool in ${node_tools[@]}; do
		sudo npm install -g $tool
	done
fi

if check "cargo"; then
	for tool in ${rust_tools[@]}; do
		cargo install $tool
	done
fi

if check "go"; then
	check "go-global-update" || go install github.com/Gelio/go-global-update@latest
	check "staticcheck" || go install honnef.co/go/tools/cmd/staticcheck@latest
	check "shfmt" || go install mvdan.cc/sh/v3/cmd/shfmt@latest
	check "goimports" || go install golang.org/x/tools/cmd/goimports@latest
	check "gomodifytags" || go install github.com/fatih/gomodifytags@latest
	check "flarectl" || go install github.com/cloudflare/cloudflare-go/cmd/flarectl@latest
	check "sops" || go install go.mozilla.org/sops/v3/cmd/sops@latest
	check "k9s" || go install github.com/derailed/k9s/cmd/k9s@latest
	check "duf" || go install github.com/muesli/duf@latest
fi

# Add zsh plugin manager
if [[ -e "$HOME/.config/antidote" ]]; then
	git -C $HOME/.config/antidote pull
else
	git clone --depth=1 https://github.com/mattmc3/antidote.git ${ZDOTDIR:-~}/.config/antidote
fi
