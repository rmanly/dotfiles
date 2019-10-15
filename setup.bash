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
[[ -e $HOME/.zshrc ]] && /bin/rm $HOME/.zshrc

/bin/ln -s $HOME/src/dotfiles/bash_profile $HOME/.bash_profile
/bin/ln -s $HOME/src/dotfiles/bash_prompt $HOME/.bash_prompt
/bin/ln -s $HOME/src/dotfiles/bashrc $HOME/.bashrc
/bin/ln -s $HOME/src/dotfiles/gitconfig $HOME/.gitconfig
/bin/ln -s $HOME/src/dotfiles/gitignore $HOME/.gitignore
/bin/ln -s $HOME/src/dotfiles/inputrc $HOME/.inputrc
/bin/ln -s $HOME/src/dotfiles/vimrc $HOME/.vimrc
/bin/ln -s $HOME/src/dotfiles/zshrc $HOME/.zshrc

printf "%s\n" "Don't forget to source your shell rc!" "You may want to do the following as well:" "sudo ln -s /Applications/MacVim.app/Contents/bin/mvim /usr/local/bin/mvim"
