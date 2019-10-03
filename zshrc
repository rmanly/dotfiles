HISTFILE=${ZDOTDIR:-$HOME}/.zsh_history
HISTSIZE=2500
SAVEHIST=1000
setopt correct_all auto_cd hist_ignore_all_dups append_history share_history
unsetopt beep

autoload -Uz compinit && compinit
autoload -Uz colors && colors

# quit if fits on one screen, case insensitive search, don't clear on quit, highlight new line
export LESS=FiWX
export GREP_OPTIONS='--color=auto'
[[ -d /Volumes/Ministack/.vagrant.d ]] && export VAGRANT_HOME=/Volumes/Ministack/.vagrant.d

# ----------------------------------------------------------------------
# PROMPT
# ----------------------------------------------------------------------

local green="%{$fg_no_bold[green]%}"
local orange="%F{166}"
local red="%{$fg_no_bold[red]%}"
local reset="%{$reset_color%}"
local white="%{$fg_no_bold[white]%}"
local yellow="%{$fg_no_bold[yellow]%}"

# Highlight the user name when logged in as root.
if [[ "${USER}" == "root" ]]; then
	userStyle="${red}";
else
	userStyle="${orange}";
fi;

# Highlight the hostname when connected via SSH.
# A limitation I found here sudo doesn't keep
# ENV vars and so ssh_tty isn't set after a sudo -s
if [[ "${SSH_TTY}" ]]; then
	hostStyle="${red}";
else
	hostStyle="${yellow}";
fi;

PROMPT=""$'\n'"${userStyle}%n ${white}at ${hostStyle}%m${white}: ${green}%~"$'\n'"${white}%#${reset} "

# ----------------------------------------------------------------------
# ALIAS
# ----------------------------------------------------------------------

if [[ $(uname) == Darwin ]]; then
    alias ls='ls -G'
    alias ll='ls -G -la'
    alias readmunki='/usr/bin/defaults read /Library/Preferences/ManagedInstalls'
    alias sha256='/usr/bin/shasum -a 256'
    alias snapshot='/usr/bin/tmutil snapshot'

    cd() {
        builtin cd "${@:-$HOME}" && /bin/ls -G;
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
