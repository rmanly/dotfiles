# Add deno completions to search path
if [[ ":$FPATH:" != *":$HOME/.zsh/completions:"* ]]; then export FPATH="$HOME/.zsh/completions:$FPATH"; fi
bindkey -v
KEYTIMEOUT=10

CORRECT_IGNORE_FILE='.*'
DIRSTACKSIZE=4
HISTFILE=${ZDOTDIR:-$HOME}/.zsh_history
HISTSIZE=10500
SAVEHIST=10000

setopt always_to_end auto_cd auto_pushd brace_ccl complete_in_word correct extended_history hist_expire_dups_first hist_find_no_dups hist_ignore_space hist_reduce_blanks hist_save_no_dups hist_verify numeric_glob_sort pushd_ignore_dups share_history
unsetopt beep

autoload -Uz compinit && compinit
autoload -Uz colors && colors

# Keep Python's generic environment name out of the prompt. A project-aware
# virtualenv segment is added to PS1 below instead.
export VIRTUAL_ENV_DISABLE_PROMPT=1

# quit if fits on one screen, case insensitive search, don't clear on quit, highlight new line
export LESS=FiWX

# [[ -d /Volumes/Ministack/.vagrant.d ]] && export VAGRANT_HOME=/Volumes/Ministack/.vagrant.d

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

function virtualenv_prompt() {
	[[ -z "$VIRTUAL_ENV" ]] && return

	local environment_name="${VIRTUAL_ENV:t}"
	if [[ "$environment_name" == '.venv' || "$environment_name" == 'venv' ]]; then
		environment_name="${VIRTUAL_ENV:h:t}"
	fi

	print -n -- " %F{cyan}[py:${environment_name}]%f"
}

setopt prompt_subst
PS1=""$'\n'"${userStyle}%n%f %F{white}at%f ${hostStyle}%m%f%F{white}:%f %F{green}%~%f"'$(virtualenv_prompt)'$'\n'"%F{gray}%*%f %F{white}%#%f "

# ----------------------------------------------------------------------
# ALIAS
# ----------------------------------------------------------------------

alias -s pkginfo=vim
alias -s plist=vim
if [[ $(uname) == Darwin ]]; then
    chpwd() {
        emulate -L zsh;
        /bin/ls -G;
    }

else
    cd() {
        builtin cd "${@:-$HOME}" && /bin/ls --color;
    }
fi

# ----------------------------------------------------------------------
# FUNCTIONS
# ----------------------------------------------------------------------

# ----------------------------------------------------------------------
# Vi-Mode
# ----------------------------------------------------------------------

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


# ----------------------------------------------------------------------
# Path
# ----------------------------------------------------------------------

export PATH="$PATH:$HOME/Library/Python/3.14/bin:$HOME/.local/bin"

# Bun (required by gstack)
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# zsh-nvm for using openai codex
# https://github.com/lukechilds/zsh-nvm
export NVM_LAZY_LOAD=true
[[ -f ~/.zsh-nvm/zsh-nvm.plugin.zsh ]] && source ~/.zsh-nvm/zsh-nvm.plugin.zsh

[[ -e $HOME/bin/gam7 ]] && alias gam="$HOME/bin/gam7/gam"

[[ -r "$HOME/.deno/env" ]] && source "$HOME/.deno/env"

_dotfiles_zsh_dir=${${(%):-%N}:A:h}
source "$_dotfiles_zsh_dir/shell_functions"
unset _dotfiles_zsh_dir

# Auto-activate Python venv when entering a directory containing .venv
typeset -g _dotfiles_auto_venv=''

function auto_venv() {
  local target="$PWD/.venv"

  if [[ -n "$_dotfiles_auto_venv" && "$VIRTUAL_ENV" == "$_dotfiles_auto_venv" && "$target" != "$_dotfiles_auto_venv" ]]; then
    deactivate
    _dotfiles_auto_venv=''
  fi

  if [[ -z "$VIRTUAL_ENV" && -r "$target/bin/activate" ]]; then
    source "$target/bin/activate"
    _dotfiles_auto_venv="$VIRTUAL_ENV"
  fi
}

autoload -U add-zsh-hook
add-zsh-hook chpwd auto_venv

# run once on shell start
auto_venv
