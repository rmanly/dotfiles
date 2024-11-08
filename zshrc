bindkey -v

CORRECT_IGNORE_FILE='.*'
DIRSTACKSIZE=4
HISTFILE=${ZDOTDIR:-$HOME}/.zsh_history
HISTSIZE=10500
SAVEHIST=10000

setopt append_history auto_cd auto_pushd brace_ccl correct_all extended_history hist_expire_dups_first hist_find_no_dups hist_ignore_space hist_no_store hist_reduce_blanks pushd_ignore_dups share_history
unsetopt beep

autoload -Uz compinit && compinit
autoload -Uz colors && colors

# quit if fits on one screen, case insensitive search, don't clear on quit, highlight new line
export LESS=FiWX

# [[ -d /Volumes/Ministack/.vagrant.d ]] && export VAGRANT_HOME=/Volumes/Ministack/.vagrant.d

today=$(/bin/date +'%Y-%m-%d')

# ----------------------------------------------------------------------
# PROMPT
# ----------------------------------------------------------------------

# Highlight the user name when logged in as root.
if [[ "${USER}" == "root" ]]; then
	userStyle='%F{red}';
else
	userStyle='%F{166}';
fi;

# Highlight the hostname when connected via SSH.
# A limitation I found here sudo doesn't keep
# ENV vars and so ssh_tty isn't set after a sudo -s
if [[ "${SSH_TTY}" ]]; then
	hostStyle='%F{red}';
else
	hostStyle='%F{yellow}';
fi;

PS1=""$'\n'"${userStyle}%n%f %F{white}at%f ${hostStyle}%m%f%F{white}:%f %F{green}%~%f"$'\n'"%F{gray}%*%f %F{white}%#%f "

# ----------------------------------------------------------------------
# ALIAS
# ----------------------------------------------------------------------

alias -s pkginfo=vim
alias -s plist=vim
alias grep='grep --color=auto'

if [[ $(uname) == Darwin ]]; then
    alias chimeon='nvram StartupMute=%00'
    alias chimeoff='nvram StartupMute=%01'
    alias ls='ls -G'
    alias ll='ls -G -la'
    alias readmunki='/usr/bin/defaults read /Library/Preferences/ManagedInstalls'
    alias sha256='/usr/bin/shasum -a 256'

    chpwd() {
        emulate -L zsh;
        /bin/ls -G;
    }

    ip() {
        devices=($(networksetup -listnetworkserviceorder | awk -F': ' '/Port/{ gsub(/\)$/,""); print $3 }'))

        for iface in "${devices[@]}"; do
            if ! ipconfig getifaddr "$iface"; then
                continue
            else
                break
            fi
        done
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

    recover() {
        box "TYPE THIS!"
        printf "%s\n" 'sudo nvram "recovery-boot-mode=unused"'
    }

    rmds() {
        /usr/bin/find . -name \.DS_Store -delete
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

# TODO: test and read about switching to '-S vcodec:h264,res,acodec:m4a'
# not seeing 22 too much anymore and VP09 is messing with my quicklook

ydl() {
    /usr/local/bin/yt-dlp -o "$HOME/Downloads/ydl $today/%(uploader)s-%(title)s.%(ext)s" "$1"
}

ydla() {
    /usr/local/bin/yt-dlp -a "$1" -o "$HOME/Downloads/ydl $today/%(uploader)s-%(title)s.%(ext)s"
}

ydlm() {
    /usr/local/bin/yt-dlp -f "m4a/aac/bestaudio" \
        -o "$HOME/Downloads/ydl $today/audio/%(uploader)s-%(title)s.%(ext)s" "$1"
}

ydlmch() {
    /usr/local/bin/yt-dlp --ignore-config \
        -f "m4a/aac/bestaudio" \
        --replace-in-metadata "title,uploader,playlist" "[\/:\\\"|]" "" \
        --output-na-placeholder "" --embed-thumbnail --split-chapters \
        -o "$HOME/Downloads/ydl $today/audio/%(title)s/%(chapter)s.%(ext)s" \
        -o chapter:"$HOME/Downloads/ydl $today/audio/%(title)s/%(section_number)03d - %(section_title)s.%(ext)s" "$1"
}

ydlmk() {
    # download multiple formats using ',' default method and then audio in preferred order -- UPDATE: doesnt work if no format available
    # /usr/local/bin/yt-dlp -f "bestvideo*+bestaudio/best,m4a/aac/bestaudio" -o "$HOME/Downloads/ydl $today/audio/%(title)s.%(ext)s" "$1"
    /usr/local/bin/yt-dlp -x -k \
        -o "$HOME/Downloads/ydl $today/audio/%(uploader)s-%(title)s.%(ext)s" "$1"
}

ydlpl() {
    /usr/local/bin/yt-dlp \
        -o "$HOME/Downloads/%(uploader)s/%(playlist)s/%(upload_date)s-%(playlist_index)s-%(title)s.%(ext)s" "$1"
}

ydlpla() {
    /usr/local/bin/yt-dlp \
        -o "$HOME/Downloads/%(uploader)s/%(playlist)s/%(upload_date)s-%(playlist_index)s-%(title)s.%(ext)s" -a "$1"
}

ydlu() {
    /usr/local/bin/yt-dlp \
        -o "$HOME/Downloads/ydl $today/%(uploader)s/%(release_date>%Y-%m-%d,upload_date>%Y-%m-%d|Unknown)s-%(title)s.%(ext)s" "$1"
}


# ----------------------------------------------------------------------
# Vi-Mode Testing
# ----------------------------------------------------------------------

# fix for error on Ubuntu when typing up & down arrow for the history bindings below
[[ ! -f ~/.zshenv || -z $(grep DEBIAN_PREVENT_KEYBOARD_CHANGES ~/.zshenv) ]] &&
	print "DEBIAN_PREVENT_KEYBOARD_CHANGES=yes" >> ~/.zshenv

# http://stratus3d.com/blog/2017/10/26/better-vi-moden-zshell/
# Better searching in command mode
bindkey -M vicmd '/' history-incremental-search-backward
bindkey -M vicmd '?' history-incremental-search-forward

# `v` is already mapped to visual mode, so we need to use a different key to
# open Vim
autoload edit-command-line; zle -N edit-command-line
bindkey -M vicmd "^V" edit-command-line

# ----------------------------------------------------------------------
# Misc
# ----------------------------------------------------------------------

# https://github.com/rothgar/mastering-zsh/blob/master/docs/helpers/widgets.md
# Prepend sudo to a command and put your cursor back to the previous location with esc,s
function prepend-sudo {
  if [[ $BUFFER != "sudo "* ]]; then
    BUFFER="sudo $BUFFER"; CURSOR+=5
  fi
}
zle -N prepend-sudo

bindkey -M vicmd s prepend-sudo

# https://github.com/rothgar/mastering-zsh/blob/master/docs/usage/line_movement.md
# add emacs style search and line movement as well
bindkey '^r' history-incremental-search-backward
bindkey '^a' beginning-of-line
bindkey '^e' end-of-line
# Also fix annoying vi backspace
bindkey '^?' backward-delete-char

alias gam="/Users/ryan/bin/gamadv-xtd3/gam"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# ----------------------------------------------------------------------
# Path
# ----------------------------------------------------------------------

# https://stackoverflow.com/questions/11530090/adding-a-new-entry-to-the-path-variable-in-zsh
# append
# path+=('/home/david/pear/bin')
# or prepend
# path=('/Users/rmanly/Library/Python/3.9/bin' $path)
# export to sub-processes (make it inherited by child processes)
export PATH

alias gam="/Users/rmanly/bin/gamadv-xtd3/gam"

# Added by LM Studio CLI (lms)
export PATH="$PATH:/Users/rmanly/.cache/lm-studio/bin"
