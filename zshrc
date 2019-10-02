HISTFILE=${ZDOTDIR:-$HOME}/.zsh_history
HISTSIZE=1000
SAVEHIST=1000
setopt correct_all auto_cd hist_ignore_all_dups append_history share_history
unsetopt beep

autoload -Uz compinit
compinit

autoload -Uz colors && colors

#keep man pages on screen after quit
#TODO: fix this for git log
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

alias sshv='ssh -vvv -o LogLevel=DEBUG3'
alias ll='ls -la'

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

calc() {
	awk "BEGIN{ print $* }";
}

pman () {
	man -t "${1}" | open -f -a /Applications/Preview.app
}

box() {
	c=${2-=}; l=$c$c${1//?/$c}$c$c; echo -e "$l\n$c $1 $c\n$l"; unset c l;
}

dirperm() {
	dir=$(pwd);
	while [ ! -z "$dir" ]; do
		ls -led "$dir";
		dir=${dir%/*};
	done;
ls -led /;
}
