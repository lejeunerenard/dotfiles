#! /usr/bin/env bash

DOTFILES=$(dirname "$0")
TERMINFO_PATH=$HOME/.terminfo
TEMPLATES=( "terminfo-templates/tmux.terminfo" "terminfo-templates/tmux-256color.terminfo" "terminfo-templates/xterm-256color.terminfo" )
for TEMPLATE in "${TEMPLATES[@]}"; do
  tic -o $TERMINFO_PATH $DOTFILES/$TEMPLATE
done
