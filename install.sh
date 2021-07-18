#!/bin/sh

git submodule update --init --recursive

setup="export ZDOTDIR=$PWD"
zshenv="$HOME/.zshenv"
init=$zshenv

if ! grep -qs "$setup" $init; then
  echo "$setup" >> $init
fi
