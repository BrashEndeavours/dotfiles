#!/bin/bash

# scripts
mkdir -p ./data/scripts
cp -ar ~/.scripts/ ./data/scripts/*

# dotfiles
mkdir -p ./data/
cp -a ~/.vimrc ./data/
cp -a ~/.bashrc ./data/
cp -a ~/.gitconfig ./data/

# terminator config
mkdir -p ./data/etc/terminator
cp ~/.config/terminator/config ./data/etc/terminator
