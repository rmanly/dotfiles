#!/bin/bash

for item in ./dotfiles/*; do
    ln -s "${item}" "$HOME/.${foo##*/}"
done
