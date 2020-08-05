#!/bin/sh

git submodule update --init --recursive

setup="cd $PWD; source .zshrc; cd -"
zshrc="$HOME/.zshrc"

if ! grep -qs "$setup" $zshrc; then
  echo "$setup" >> $zshrc
fi
