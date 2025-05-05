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

if [[ $(uname) == Darwin ]]; then
    [[ -e $HOME/Library/Application\ Support/com.mitchellh.ghostty/config ]] && /bin/rm $HOME/Library/Application\ Support/com.mitchellh.ghostty/config
    /bin/ln -s $HOME/src/dotfiles/ghostty $HOME/Library/Application\ Support/com.mitchellh.ghostty/config
    /bin/mkdir -p "$HOME/Library/Fonts"
    /usr/bin/find "$HOME/src/dotfiles" -type f \( -iname "*.ttf" -o -iname "*.otf" \) -exec cp "{}" "$HOME/Library/Fonts/" \;
    /usr/bin/defaults write com.apple.Safari AutoOpenSafeDownloads -boolean NO
    /usr/bin/defaults write com.apple.finder _FXShowPosixPathInTitle -bool TRUE
    /usr/bin/killall Finder
fi

ytdlp_user_conf=(
    $HOME/yt-dlp.conf
    $HOME/yt-dlp.conf.txt
    $HOME/.yt-dlp/config
    $HOME/.yt-dlp/config.txt
)

for conf in "${yt-dlp_user_conf[@]}"; do
    [[ -e $conf ]] && /bin/rm $conf
done 

/bin/mkdir -p $HOME/.yt-dlp
/bin/ln -s $HOME/src/dotfiles/yt-dlp_config $HOME/.yt-dlp/config

printf "%s\n" "Don't forget to source your shell rc!"
