set -o vi

shopt -s cdspell
shopt -s checkjobs
shopt -s checkwinsize
shopt -s cmdhist
shopt -s extglob
shopt -s failglob
shopt -s globstar
shopt -s histappend
shopt -s histreedit

export EDITOR=/usr/bin/vim
export GLOBIGNORE=.:..
export GREP_OPTIONS='--color=auto'
export HISTCONTROL=ignoreboth
export HISTIGNORE='fg:bg:ls:pwd:cd ..:cd -:cd:jobs:set -x:ls -l:history:open ./:'
export HISTSIZE=2500
export HISTTIMEFORMAT="%Y-%m-%d %T "
export PROMPT_COMMAND='history -a; history -r'

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
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:/usr/X11/bin

[[ -e /usr/local/git/bin ]] && PATH=/usr/local/git/bin:$PATH
[[ -e /usr/local/munki ]] && PATH=/usr/local/munki:$PATH
[[ -e /Library/Frameworks/Python.framework/Versions/3.4/bin ]] && PATH=$PATH:/Library/Frameworks/Python.framework/Versions/3.4/bin
[[ -e $HOME/Dropbox/bin ]] && PATH=$PATH:$HOME/Dropbox/bin
[[ -e /Volumes/Drobo/Dropbox/bin ]] && PATH=$PATH:/Volumes/Drobo/Dropbox/bin
[[ -e /Applications/Server.app ]] && PATH=$PATH:/Applications/Server.app/Contents/ServerRoot/usr/sbin:/Applications/Server.app/Contents/ServerRoot/usr/bin
[[ -e $HOME/anaconda/bin ]] && PATH=$PATH:$HOME/anaconda/bin

export PATH

# ----------------------------------------------------------------------
# PROMPT
# ----------------------------------------------------------------------

if [[ ${EUID} == 0 ]] ; then
    PS1='\[\033[01;31m\]\h\[\033[01;34m\] \W \$\[\033[00m\] '
else
    PS1='\[\033[00;32m\]\u@\h\[\033[00;34m\] \W \$\[\033[00m\] '
fi

export PS4='+(${BASH_SOURCE}:${LINENO}): ${FUNCNAME[0]:+${FUNCNAME[0]}(): }'

# ----------------------------------------------------------------------
# ALIAS & OS-SPECIFIC FUNCTIONS
# ----------------------------------------------------------------------


if [[ $(uname) == Darwin ]]; then
    alias ls='ls -G'
    alias readmunki='/usr/bin/defaults read /Library/Preferences/ManagedInstalls'

    cd() {
        builtin cd "${@:-$HOME}" && /bin/ls -G;
    }

    files() {
        /usr/sbin/pkgutil --files "$1"
    }

    forget() {
        /usr/sbin/pkgutil --forget "$1"
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
    for file in ./*; do
        mv -- "$file" "$1-${file#*/}";
    done
}

vboxip() {
    VBoxManage guestproperty get "$1" "/VirtualBox/GuestInfo/Net/0/V4/IP"
}

vboxhead() {
    VBoxManage startvm "$1" --type headless
}

vboxstop() {
    VboxManage controlvm "$1" poweroff
}

vboxnatssh() {
    VBoxManage modifyvm "$1" --natpf1 "$1-ssh,tcp,,2222,,22" && \
        printf "%s\n" "Start the VM and ssh via localhost:2222" \
        "Remove rule with 'VBoxManage modifyvm $1 --natpf1 delete $1-ssh'"
}

ydl() {
    /usr/local/bin/youtube-dl -ciw -f best --restrict-filenames -o "$HOME/Downloads/%(title)s.%(ext)s" "$1"
}

ydlasmr() {
    /usr/local/bin/youtube-dl -ciw -f best --restrict-filenames -o "$HOME/Downloads/%(uploader)s-%(title)s.%(ext)s" "$1"
}

ydla() {
    /usr/local/bin/youtube-dl -ciw -f best --restrict-filenames -a "$1" -o "$HOME/Downloads/%(title)s.%(ext)s"
}

ydlm() {
    /usr/local/bin/youtube-dl -ciw -f best --restrict-filenames -x --audio-format "mp3" -o "$HOME/Dropbox/audio/%(title)s.%(ext)s" "$1"
}

ydlmasmr() {
    /usr/local/bin/youtube-dl -ciw -f best --restrict-filenames -x --audio-format "mp3" -o "$HOME/Dropbox/audio/%(uploader)s-%(title)s.%(ext)s" "$1"
}

ydlpl() {
    /bin/mkdir -p "$HOME/Downloads/$2"
    /usr/local/bin/youtube-dl -ciw -f best --restrict-filenames -o "$HOME/Downloads/$2/%(playlist_index)s-%(title)s.%(ext)s" "$1"
}

ydlmk() {
    /usr/local/bin/youtube-dl -ciwk -f best --restrict-filenames -x --audio-format "mp3" -o "$HOME/Downloads/%(title)s.%(ext)s" "$1"
}

ydlmkasmr() {
    /usr/local/bin/youtube-dl -ciwk -f best --restrict-filenames -x --audio-format "mp3" -o "$HOME/Downloads/%(uploader)s-%(title)s.%(ext)s" "$1"
}

ydlu() {
    /bin/mkdir -p "$HOME/Downloads/$1"
    /usr/local/bin/youtube-dl -ciw -f best --restrict-filenames -o "$HOME/Downloads/$1/%(uploader)s/%(title)s.%(ext)s" ytuser:"$1"
}

# ----------------------------------------------------------------------
# VIRTUALENV
# ----------------------------------------------------------------------

# export WORKON_HOME="$HOME/virtual_py"
# source $(which virtualenvwrapper.sh)
