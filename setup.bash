#!/usr/bin/env bash

if [[ -d $HOME/src/dotfiles/.git ]]; then
    git --git-dir=$HOME/src/dotfiles/.git --work-tree=$HOME/src/dotfiles fetch --all
    git --git-dir=$HOME/src/dotfiles/.git --work-tree=$HOME/src/dotfiles reset --hard origin/master
else
    git clone https://github.com/rmanly/dotfiles.git $HOME/src/dotfiles
fi

[[ -e $HOME/.bashrc ]] && /bin/rm $HOME/.bashrc
[[ -e $HOME/.bash_profile ]] && /bin/rm $HOME/.bash_profile
[[ -e $HOME/.bash_prompt ]] && /bin/rm $HOME/.bash_prompt
[[ -e $HOME/.vimrc ]] && /bin/rm $HOME/.vimrc

/bin/ln -s $HOME/src/dotfiles/bashrc $HOME/.bashrc
/bin/ln -s $HOME/src/dotfiles/bash_profile $HOME/.bash_profile
/bin/ln -s $HOME/src/dotfiles/bash_prompt $HOME/.bash_prompt
/bin/ln -s $HOME/src/dotfiles/vimrc $HOME/.vimrc

echo "Don't forget to source bashrc!"
