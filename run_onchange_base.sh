#!/bin/bash

# Add zsh plugin manager
if [[ -e "$HOME/.antidote" ]]; then
	git -C $HOME/.antidote pull
else
	git clone --depth=1 https://github.com/mattmc3/antidote.git ${ZDOTDIR:-~}/.antidote
fi

# Add flathub
if type flatpak >/dev/null; then
	flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
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
fi

# Add go extensions
if type go >/dev/null; then
	type staticcheck &>/dev/null || go install honnef.co/go/tools/cmd/staticcheck@latest
	type shfmt &>/dev/null || go install mvdan.cc/sh/v3/cmd/shfmt@latest
	type goimports &>/dev/null || go install golang.org/x/tools/cmd/goimports@latest
	type gomodifytags &>/dev/null || go install github.com/fatih/gomodifytags@latest
fi

# Add nerd fonts
required_fonts=(FiraCode FiraMono SourceCodePro JetBrainsMono SpaceMono Noto)
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
