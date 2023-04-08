#!/bin/bash

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
if [[ ! -e "$HOME/.nvm/nvm.sh" ]]; then
	curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | bash
	nvm install --lts
fi

# Add npm and base packages
if type npm >/dev/null; then
	type prettier &>/dev/null || npm install -g prettier
	type eslint_d &>/dev/null || npm install -g eslint_d
fi

# Add go extensions
if type go >/dev/null; then
	type staticcheck &>/dev/null || go install honnef.co/go/tools/cmd/staticcheck@latest
	type shfmt &>/dev/null || go install mvdan.cc/sh/v3/cmd/shfmt@latest
	type goimports &>/dev/null || go install golang.org/x/tools/cmd/goimports@latest
	type gomodifytags &>/dev/null || go install github.com/fatih/gomodifytags@latest
	type flarectl &>/dev/null || go install github.com/cloudflare/cloudflare-go/cmd/flarectl@latest
fi
