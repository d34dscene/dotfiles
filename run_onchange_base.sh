#!/bin/bash

if [[ -e "$HOME/.antidote" ]]; then
	git -C $HOME/.antidote pull
else
	git clone --depth=1 https://github.com/mattmc3/antidote.git ${ZDOTDIR:-~}/.antidote
fi
