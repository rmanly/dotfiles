#!/usr/bin/env bash -x

if [[ -d $HOME/src/dotfiles/.git ]]; then
    git --git-dir=$HOME/src/dotfiles/.git fetch --all
    git --git-dir=$HOME/src/dotfiles/.git reset --hard origin/master
else
    git clone https://github.com/rmanly/dotfiles.git $HOME/src/dotfiles
fi

if [[ -d $HOME/.vim/bundle/Vundle.vim/.git ]]; then
    git --git-dir=$HOME/.vim/bundle/Vundle.vim/.git fetch --all
    git --git-dir=$HOME/.vim/bundle/Vundle.vim/.git reset --hard origin/master
else
    git clone https://github.com/VundleVim/Vundle.vim.git $HOME/.vim/bundle/Vundle.vim
fi

[[ -e $HOME/.bashrc ]] && /bin/rm $HOME/.bashrc
[[ -e $HOME/.bash_profile ]] && /bin/rm $HOME/.bash_profile
[[ -e $HOME/.vimrc ]] && /bin/rm $HOME/.vimrc

/bin/ln -s $HOME/src/dotfiles/bashrc $HOME/.bashrc
/bin/ln -s $HOME/src/dotfiles/bash_profile $HOME/.bash_profile
/bin/ln -s $HOME/src/dotfiles/vimrc $HOME/.vimrc
