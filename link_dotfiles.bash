#!/bin/bash

shopt -s nullglob

if [[ -z $1 ]]; then
    echo "Must supply path to dotfiles repo."
    exit 1
fi

for item in "$1"; do
    ln -s "${item}" "$HOME/.${foo##*/}"
done
