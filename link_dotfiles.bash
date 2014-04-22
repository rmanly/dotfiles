#!/bin/bash

for foo in ./dotfiles/*; do
    ln -s "${foo}" "$HOME/.${foo##*/}"
done
