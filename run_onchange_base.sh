#!/bin/bash

# Add zsh plugin manager
if [[ -e "$HOME/.antidote" ]]; then
	git -C $HOME/.antidote pull
else
	git clone --depth=1 https://github.com/mattmc3/antidote.git ${ZDOTDIR:-~}/.antidote
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