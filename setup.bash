#!/usr/bin/env bash

git clone https://github.com/rmanly/dotfiles.git $HOME/src/dotfiles
git clone https://github.com/VundleVim/Vundle.vim.git $HOME/.vim/bundle/Vundle.vim

ln -s $HOME/src/dotfiles/bashrc $HOME/.bashrc
ln -s $HOME/src/dotfiles/bash_profile $HOME/.bash_profile
ln -s $HOME/src/dotfiles/vimrc $HOME/.vimrc
