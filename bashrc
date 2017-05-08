set -o vi

shopt -s cdspell
shopt -s checkwinsize
shopt -s cmdhist
shopt -s extglob
shopt -s failglob
shopt -s histappend
shopt -s histreedit

if [[ ${BASH_VERSINFO[0]} -ge 4 ]]; then
    shopt -s checkjobs
    shopt -s globstar
fi

export EDITOR=/usr/bin/vim
export GREP_OPTIONS='--color=auto'
export HISTCONTROL=ignorespace:erasedups
export HISTIGNORE='fg:bg:ls:pwd:cd ..:cd -:cd:jobs:set -x:ls -l:history:'
export HISTSIZE=2500
export HISTTIMEFORMAT="%Y-%m-%d %T "
export PROMPT_COMMAND='history -a; history -r'
export PROMPT_DIRTRIM=2

# http://cnswww.cns.cwru.edu/php/chet/readline/readline.html#SEC13
# zsh style tab completions...kinda
bind '\C-i':menu-complete
# set to match highlight removal for vim
bind '\C-l':clear-screen

# quit if fits on one screen, case insensitive search, don't clear on quit, highlight new line
export LESS=FiWX


# ----------------------------------------------------------------------
# PATHS
# ----------------------------------------------------------------------

unset PATH
PATH=/usr/local/bin:/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/sbin:/usr/X11/bin

[[ -e $HOME/Dropbox/bin ]] && PATH=$PATH:$HOME/Dropbox/bin
[[ -e $HOME/anaconda/bin ]] && PATH=$PATH:$HOME/anaconda/bin
[[ -e /Applications/Server.app ]] && PATH=$PATH:/Applications/Server.app/Contents/ServerRoot/usr/sbin:/Applications/Server.app/Contents/ServerRoot/usr/bin
[[ -e /Library/Frameworks/Python.framework/Versions/3.5/bin ]] && PATH=$PATH:/Library/Frameworks/Python.framework/Versions/3.5/bin
[[ -e /Volumes/Drobo/Dropbox/bin ]] && PATH=$PATH:/Volumes/Drobo/Dropbox/bin
[[ -e /usr/local/git/bin ]] && PATH=/usr/local/git/bin:$PATH
[[ -e /usr/local/go/bin ]] && PATH=/usr/local/go/bin:$PATH
[[ -e /usr/local/munki ]] && PATH=/usr/local/munki:$PATH
[[ -e /usr/local/vfuse ]] && PATH=/usr/local/vfuse:$PATH

export PATH


# ----------------------------------------------------------------------
# PROMPT
# ----------------------------------------------------------------------

if [[ -e $HOME/.bash_prompt ]]; then
    source $HOME/.bash_prompt
else
    if [[ ${EUID} == 0 ]] ; then
        PS1='\[\033[01;31m\]\h\[\033[01;34m\] \W \$\[\033[00m\] '
    else
        PS1='\[\033[00;32m\]\u@\h\[\033[00;34m\] \W \$\[\033[00m\] '
    fi
fi

export PS4='+(${BASH_SOURCE}:${LINENO}): ${FUNCNAME[0]:+${FUNCNAME[0]}(): }'


# ----------------------------------------------------------------------
# ALIAS & OS-SPECIFIC FUNCTIONS
# ----------------------------------------------------------------------

if [[ $(uname) == Darwin ]]; then
    alias ls='ls -G'
    alias ll='ls -G -la'
    alias readmunki='/usr/bin/defaults read /Library/Preferences/ManagedInstalls'
    alias sha256='/usr/bin/shasum -a 256'

    cd() {
        builtin cd "${@:-$HOME}" && /bin/ls -G;
    }

    ip() {
        /usr/sbin/networksetup -getinfo "Thunderbolt Ethernet" | awk '/^IP /{ print $3 }';
        /usr/sbin/ipconfig getifaddr en0 2> /dev/null;
    }

    ncl() {
        port=9999
        ip=$(ip);
        printf "%s\n" "Use the following command to connect to this computer." 
        box "nc ${ip} ${1:-$port}" -
        /usr/bin/nc -l "${1:-$port}";
    }

    profix() {
        /usr/bin/xmllint -format "$1" > "${1%.*}".plist
    }

    writemunki() {
        /usr/bin/sudo /usr/bin/defaults write /Library/Preferences/ManagedInstalls "$1" "$2"
    }
else
    alias ls='ls --color'

    cd() {
        builtin cd "${@:-$HOME}" && /bin/ls --color;
    }
fi


# ----------------------------------------------------------------------
# FUNCTIONS
# ----------------------------------------------------------------------

md() {
    /bin/mkdir -p "$1" && builtin cd "$1";
}

box() {
    c=${2-#}; l=$c$c${1//?/$c}$c$c;
    echo -e "$l\n$c $1 $c\n$l";
    unset c l;
}

dirperm() {
    dir=$PWD;
    while [[ ! -z "$dir" ]]; do
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
    filename="${1##*/}"
    name="${filename%.*}"
    sips -s format png --resampleHeight 128 "$1" --out $HOME/Desktop/"${name}-128.png"
}

ydl() {
    /usr/local/bin/youtube-dl -i -f 'bestvideo[ext=mp4]+bestaudio[ext=m4a]' --restrict-filenames -o "$HOME/Desktop/ydl/%(title)s.%(ext)s" "$1"
}

ydlasmr() {
    /usr/local/bin/youtube-dl -i -f 'bestvideo[ext=mp4]+bestaudio[ext=m4a]' --restrict-filenames -o "$HOME/Desktop/ydl/ASMR/%(uploader)s-%(title)s.%(ext)s" "$1"
}

ydla() {
    /usr/local/bin/youtube-dl -i --restrict-filenames -a "$1" -o "$HOME/Desktop/ydl/%(title)s.%(ext)s"
}

ydlm() {
    /usr/local/bin/youtube-dl -i --restrict-filenames -x --audio-format "mp3" -o "$HOME/Desktop/ydl/audio/%(title)s.%(ext)s" "$1"
}

ydlmasmr() {
    /usr/local/bin/youtube-dl -i --restrict-filenames -x --audio-format "mp3" -o "$HOME/Desktop/ydl/audio/ASMR/%(uploader)s-%(title)s.%(ext)s" "$1"
}

ydlpl() {
    /usr/local/bin/youtube-dl -i -f 'bestvideo[ext=mp4]+bestaudio[ext=m4a]' --restrict-filenames -o "$HOME/Desktop/ydl/%(playlist_title)s/%(playlist_index)s-%(title)s.%(ext)s"
}

ydlu() {
    /usr/local/bin/youtube-dl -f 'bestvideo[ext=mp4]+bestaudio[ext=m4a]' -i -o "$HOME/Desktop/ydl/%(uploader)s/%(upload_date)s-%(title)s.%(ext)s" "$1"
}


# ----------------------------------------------------------------------
# VIRTUALENV
# ----------------------------------------------------------------------

# export WORKON_HOME="$HOME/virtual_py"
# source $(which virtualenvwrapper.sh)


# ----------------------------------------------------------------------
# OTHER
# ----------------------------------------------------------------------

[[ -e $HOME/.bash_private ]] && source $HOME/.bash_private
