HISTFILE=${ZDOTDIR:-$HOME}/.zsh_history
HISTSIZE=1000
SAVEHIST=1000
setopt correct_all auto_cd hist_ignore_all_dups append_history share_history
unsetopt beep

autoload -Uz compinit
compinit

autoload -Uz colors && colors

#keep man pages on screen after quit
export LESS=FiWX

# ----------------------------------------------------------------------
# PROMPT
# ----------------------------------------------------------------------

local yellow="%{$fg_no_bold[yellow]%}"
local green="%{$fg_no_bold[green]%}"
local white="%{$fg_no_bold[white]%}"
local reset="%{$reset_color%}"

# name at host
# PROMPT=""$'\n'"${yellow}%n${reset} at ${yellow}%m${reset}: ${green}%~"$'\n'"${white}%#${reset} "

PROMPT=""$'\n'"${yellow}%n${reset}: ${green}%~"$'\n'"${white}%#${reset} "

# ----------------------------------------------------------------------
# ALIAS
# ----------------------------------------------------------------------

if [[ $(uname) == Darwin ]]; then
	alias ls='ls -G'
	alias eject='diskutil eject'
	rmattr() {
		find . -depth 1 -print0 | xargs -0 xattr -d $1;
	}
else
	alias ls='ls --color'
fi

# ----------------------------------------------------------------------
# FUNCTIONS
# ----------------------------------------------------------------------

cd() {
	builtin cd "${@:-$HOME}" && ls;
}

md() {
	mkdir -p $1 && cd $1;
}

box() {
	c=${2-=}; l=$c$c${1//?/$c}$c$c;
    echo -e "$l\n$c $1 $c\n$l";
    unset c l;
}

dirperm() {
	dir=$(pwd);
	while [ ! -z "$dir" ]; do
		ls -led "$dir";
		dir=${dir%/*};
	done;
    ls -led /;
}

pre() {
    for filename in ./*; do
        mv -- "$filename" "$1-${filename#*/}";
    done
}

s128() {
    filename="${1##*/}";
    name="${filename%.*}";
    sips -s format png --resampleHeight 128 "$1" --out $HOME/Desktop/"${name}-128.png";
}

ydl() {
    /usr/local/bin/youtube-dl -i -o "$HOME/Downloads/ydl/%(uploader)s-%(title)s.%(ext)s" "$1"
}

ydlasmr() {
    /usr/local/bin/youtube-dl -i -o "$HOME/Downloads/ydl/ASMR/%(uploader)s-%(title)s.%(ext)s" "$1"
}

ydla() {
    /usr/local/bin/youtube-dl -i -a "$1" -o "$HOME/Downloads/ydl/%(title)s.%(ext)s"
}

ydlm() {
    /usr/local/bin/youtube-dl -i -x --audio-format "mp3" -o "$HOME/Downloads/ydl/audio/%(title)s.%(ext)s" "$1"
}

ydlmk() {
    /usr/local/bin/youtube-dl -i -k -x --audio-format "mp3" -o "$HOME/Downloads/ydl/audio/%(title)s.%(ext)s" "$1"
}

ydlmasmr() {
    /usr/local/bin/youtube-dl -i -x --audio-format "mp3" -o "$HOME/Downloads/ydl/audio/ASMR/%(uploader)s-%(title)s.%(ext)s" "$1"
}

ydlpl() {
    /usr/local/bin/youtube-dl -i -f 'bestvideo[ext=mp4]+bestaudio[ext=m4a]' -o "$HOME/Downloads/ydl/%(playlist_title)s/%(playlist_index)s-%(title)s.%(ext)s"
}

ydlu() {
    /usr/local/bin/youtube-dl -i -f 'bestvideo[ext=mp4]+bestaudio[ext=m4a]' -o "$HOME/Downloads/ydl/%(uploader)s/%(upload_date)s-%(title)s.%(ext)s" "$1"
}
