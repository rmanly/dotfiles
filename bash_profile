if [[ -f $HOME/.bashrc ]]; then
   source $HOME/.bashrc
fi

if [[ -f $HOME/.bash_private ]]; then
    source $HOME/.bash_private ]]
fi


# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/Users/ryan/miniconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/Users/ryan/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/Users/ryan/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/Users/ryan/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<


<<<<<<< HEAD
# Added by LM Studio CLI (lms)
export PATH="$PATH:/Users/ryan/.cache/lm-studio/bin"
=======

# Added by LM Studio CLI (lms)
export PATH="$PATH:/Users/rmanly/.cache/lm-studio/bin"
>>>>>>> origin

alias gam="/Users/rmanly/bin/gam7/gam"
