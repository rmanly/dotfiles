bindkey -v

HISTFILE=${ZDOTDIR:-$HOME}/.zsh_history
HISTSIZE=2500
SAVEHIST=1000
CORRECT_IGNORE_FILE='.*'

setopt correct_all auto_cd hist_ignore_all_dups append_history share_history hist_ignore_space brace_ccl
unsetopt beep

autoload -Uz compinit && compinit
autoload -Uz colors && colors

# quit if fits on one screen, case insensitive search, don't clear on quit, highlight new line
export LESS=FiWX
[[ -d /Volumes/Ministack/.vagrant.d ]] && export VAGRANT_HOME=/Volumes/Ministack/.vagrant.d

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

PROMPT=""$'\n'"${userStyle}%n%f %F{white}at%f ${hostStyle}%m%f%F{white}:%f %F{green}%~%f"$'\n'"%F{white}%#%f "

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
    alias snapshot='/usr/bin/tmutil snapshot'

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

ydl() {
    today=$(/bin/date +'%Y-%m-%d')
    /usr/local/bin/youtube-dl -i -o "$HOME/Downloads/ydl $today/%(uploader)s-%(title)s.%(ext)s" "$1"
}

ydlasmr() {
    /usr/local/bin/youtube-dl -i -o "$HOME/Downloads/ydl/ASMR/%(uploader)s-%(title)s.%(ext)s" "$1"
}

ydla() {
    /usr/local/bin/youtube-dl -i -a "$1" -o "$HOME/Downloads/ydl/%(title)s.%(ext)s"
}

ydlm() {
    today=$(/bin/date +'%Y-%m-%d')
    /usr/local/bin/youtube-dl -i -x --audio-format "mp3" -o "$HOME/Downloads/ydl $today/audio/%(title)s.%(ext)s" "$1"
}

ydlmk() {
    /usr/local/bin/youtube-dl -i -k -x --audio-format "mp3" -o "$HOME/Downloads/ydl/audio/%(title)s.%(ext)s" "$1"
}

ydlmasmr() {
    today=$(/bin/date +'%Y-%m-%d')
    /usr/local/bin/youtube-dl -i -x --audio-format "mp3" -o "$HOME/Downloads/ydl $today/audio/ASMR/%(uploader)s-%(title)s.%(ext)s" "$1"
}

ydlpl() {
    /usr/local/bin/youtube-dl -i -o "/$HOME/Downloads/ydl/%(playlist_title)s/%(title)s.%(ext)s" "$1"
}

ydlpli() {
    /usr/local/bin/youtube-dl -i -o "$HOME/Downloads/ydl/%(playlist_title)s/%(playlist_index)s-%(title)s.%(ext)s" "$1"
}

ydlu() {
    /usr/local/bin/youtube-dl -i -o "$HOME/Downloads/ydl/%(uploader)s/%(upload_date)s-%(title)s.%(ext)s" "$1"
}


# ----------------------------------------------------------------------
# Vi-Mode Testing
# ----------------------------------------------------------------------

# fix for error on Ubuntu when typing up & down arrow for the history bindings below
[[ ! -f ~/.zshenv || -z $(grep DEBIAN_PREVENT_KEYBOARD_CHANGES ~/.zshenv) ]] &&
	print "DEBIAN_PREVENT_KEYBOARD_CHANGES=yes" >> ~/.zshenv

# http://stratus3d.com/blog/2017/10/26/better-vi-mode-in-zshell/
# Better searching in command mode
bindkey -M vicmd '/' history-incremental-search-backward
bindkey -M vicmd '?' history-incremental-search-forward

# `v` is already mapped to visual mode, so we need to use a different key to
# open Vim
autoload edit-command-line; zle -N edit-command-line
bindkey -M vicmd "^V" edit-command-line

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
