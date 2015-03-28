#!/bin/bash

# https://github.com/NickTomlin/dotfiles/blob/fbf9df334c1f7fbccaf90c19d63b99a89bc51686/home/.tmux.conf
# Only apply the option if on an OSX machine
if [[ $OSTYPE == "darwin"* ]]; then
   tmux set-option -g default-command "reattach-to-user-namespace -l zsh"
fi
