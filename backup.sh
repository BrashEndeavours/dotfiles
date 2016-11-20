#!/bin/bash

# scripts
mkdir -p ./data/scripts
cp -ar ~/.scripts/ ./data/scripts/*

# dotfiles
mkdir -p ./data/dotfiles
cp -a ~/.vimrc ./data/dotfiles
cp -a ~/.bashrc ./data/dotfiles
cp -a ~/.gitconfig ./data/dotfiles

# terminator config
mkdir -p ./data/config/terminator
cp ~/.config/terminator/config ./data/config/terminator
