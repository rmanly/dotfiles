set -o vi

shopt -s cdspell
shopt -s checkwinsize
shopt -s cmdhist
shopt -s extglob
shopt -s failglob
shopt -s histappend
shopt -s histreedit
shopt -s histverify
shopt -s lithist

if [[ ${BASH_VERSINFO[0]} -ge 4 ]]; then
    shopt -s checkjobs
    shopt -s globstar
fi

export HISTCONTROL=ignorespace:erasedups
export HISTIGNORE='fg:bg:ls:pwd:cd ..:cd -:cd:jobs:set -x:ls -l:history:'
export HISTSIZE=2500
export HISTFILESIZE=10000
export HISTTIMEFORMAT="%Y-%m-%d %T "
export PROMPT_COMMAND='history -a; history -n'

# http://cnswww.cns.cwru.edu/php/chet/readline/readline.html#SEC13
# zsh style tab completions...kinda
bind '\C-i':menu-complete
# set to match highlight removal for vim
bind '\C-l':clear-screen

# quit if fits on one screen, case insensitive search, don't clear on quit, highlight new line
export LESS=FiWX

# [[ -d /Volumes/Ministack/.vagrant.d ]] && export VAGRANT_HOME=/Volumes/Ministack/.vagrant.d


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
    cd() {
        builtin cd "${@:-$HOME}" && /bin/ls -G;
    }

else
    cd() {
        builtin cd "${@:-$HOME}" && /bin/ls --color;
    }
fi


# ----------------------------------------------------------------------
# FUNCTIONS
# ----------------------------------------------------------------------

[[ -r "$HOME/.bash_private" ]] && source "$HOME/.bash_private"
[[ -r "$HOME/.deno/env" ]] && source "$HOME/.deno/env"

_dotfiles_bash_source=${BASH_SOURCE[0]}
while [[ -h "$_dotfiles_bash_source" ]]; do
    _dotfiles_bash_link=$(readlink "$_dotfiles_bash_source")
    if [[ $_dotfiles_bash_link == /* ]]; then
        _dotfiles_bash_source=$_dotfiles_bash_link
    else
        _dotfiles_bash_source=$(dirname "$_dotfiles_bash_source")/$_dotfiles_bash_link
    fi
done
_dotfiles_bash_dir=$(builtin cd -- "$(dirname -- "$_dotfiles_bash_source")" && pwd -P)
source "$_dotfiles_bash_dir/shell_functions"
unset _dotfiles_bash_dir _dotfiles_bash_link _dotfiles_bash_source
