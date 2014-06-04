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

export GLOBIGNORE=.:..
export HISTCONTROL=ignoreboth
export HISTIGNORE='fg:bg:ls:pwd:cd ..:cd -:cd:jobs:set -x:ls -l:history:'
export HISTSIZE=2500
export HISTTIMEFORMAT="%m-%d-%y %T "
export PROMPT_COMMAND='history -a; history -r'

# http://cnswww.cns.cwru.edu/php/chet/readline/readline.html#SEC13
# zsh style tab completions...kinda
bind '\C-i':menu-complete
# set to match highlight removal for vim
bind '\C-l':clear-screen

# quit if fits on one screen, case insensitive search, don't clear on quit
export LESS=FiX

# ----------------------------------------------------------------------
# PATHS
# ----------------------------------------------------------------------

unset PATH
PATH=/usr/local/bin:/usr/local/sbin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/X11/bin

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

alias c='clear'
alias grep='grep --colour=auto'

if [[ $(uname) == Darwin ]]; then
    alias plb='/usr/libexec/PlistBuddy'
    alias ls='ls -G'
else
    alias ls='ls --color'
fi

# ----------------------------------------------------------------------
# FUNCTIONS
# ----------------------------------------------------------------------

cd() {
    builtin cd "${@:-$HOME}" && /bin/ls -G;
}

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

pre () {
    for file in ./*; do
        mv -- "$file" "$1-${file#*/}";
    done
}

vboxip () {
    VBoxManage guestproperty get "$1" "/VirtualBox/GuestInfo/Net/0/V4/IP"
}

vboxhead () {
    VBoxManage startvm "$1" --type headless
}

vboxstop () {
    VboxManage controlvm "$1" poweroff
}

vboxnatssh () {
    VBoxManage modifyvm "$1" --natpf1 "$1-ssh,tcp,,2222,,22" && \
        printf "%s\n" "Start the VM and ssh via localhost:2222" \
        "Remove rule with 'VBoxManage modifyvm $1 --natpf1 delete $1-ssh'"
}

ydl () {
    /usr/local/bin/youtube-dl -ciw --restrict-filenames -o "$HOME/Downloads/%(uploader)s-%(title)s.%(ext)s" "$1"
}

ydlm () {
    /usr/local/bin/youtube-dl -ciw --restrict-filenames -x --audio-format "mp3" -o "$HOME/Downloads/%(uploader)s-%(title)s.%(ext)s" "$1"
}

# ----------------------------------------------------------------------
# VIRTUALENV
# ----------------------------------------------------------------------

# export WORKON_HOME="$HOME/virtual_py"
# source $(which virtualenvwrapper.sh)
