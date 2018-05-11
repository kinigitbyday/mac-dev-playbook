#!/bin/bash

# Install YADR
if [ -d "./.yadr" ]; then
  echo "YADR repo dir exists. Removing ..."
  rm -rf ./.yadr
fi

echo "YADR rake install..."
git clone https://github.com/skwp/dotfiles.git ~/.yadr

cd ~/.yadr
rake install
