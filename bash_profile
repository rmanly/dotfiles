if [[ -f $HOME/.bashrc ]]; then
   source $HOME/.bashrc
fi

if [[ -f $HOME/.bash_private ]]; then
    source $HOME/.bash_private ]]
fi

alias gam="/Users/ryan/bin/gamadv-xtd3/gam"

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/Users/ryan/anaconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/Users/ryan/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/Users/ryan/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="/Users/ryan/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<


alias gam="/Users/rmanly/bin/gamadv-xtd3/gam"
