if [[ -f $HOME/.bashrc ]]; then
   source $HOME/.bashrc
fi

if [[ -f $HOME/.bash_private ]]; then
    source $HOME/.bash_private ]]
fi

# Added by LM Studio CLI (lms)
export PATH="$PATH:/Users/rmanly/.lmstudio/bin"
# End of LM Studio CLI section

. "/Users/rmanly/.deno/env"