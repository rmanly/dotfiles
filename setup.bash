#!/usr/bin/env bash

if [[ -d $HOME/src/dotfiles/.git ]]; then
    cd $HOME/src/dotfiles/.git
    git fetch --all
    git reset --hard origin/master
else
    git clone https://github.com/rmanly/dotfiles.git $HOME/src/dotfiles
fi

git clone https://github.com/VundleVim/Vundle.vim.git $HOME/.vim/bundle/Vundle.vim

[[ -e $HOME/.bashrc ]] && /bin/rm $HOME/.bashrc
[[ -e $HOME/.bash_profile ]] && /bin/rm $HOME/.bash_profile
[[ -e $HOME/.vimrc ]] && /bin/rm $HOME/.vimrc

/bin/ln -s $HOME/src/dotfiles/bashrc $HOME/.bashrc
/bin/ln -s $HOME/src/dotfiles/bash_profile $HOME/.bash_profile
/bin/ln -s $HOME/src/dotfiles/vimrc $HOME/.vimrc
