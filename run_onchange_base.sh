#!/bin/bash

# Add zsh plugin manager
if [[ -e "$HOME/.antidote" ]]; then
	git -C $HOME/.antidote pull
else
	git clone --depth=1 https://github.com/mattmc3/antidote.git ${ZDOTDIR:-~}/.antidote
fi

# Add nerd fonts
mkdir -p $HOME/.local/share/fonts
if [[ ! -e "$HOME/.local/share/fonts/FiraMono" ]]; then
	git clone --filter=blob:none --sparse git@github.com:ryanoasis/nerd-fonts $HOME/nerd-fonts
	git -C $HOME/nerd-fonts sparse-checkout add patched-fonts/FiraMono
	git -C $HOME/nerd-fonts sparse-checkout add patched-fonts/SourceCodePro
	mv $HOME/nerd-fonts/patched-fonts/FiraMono ~/.local/share/fonts/
	mv $HOME/nerd-fonts/patched-fonts/SourceCodePro ~/.local/share/fonts/
	rm -rf $HOME/nerd-fonts
fi
