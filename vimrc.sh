#!/bin/bash

# Install YADR
if [ -d "./.yadr" ]; then
  echo "YADR repo dir exists. Removing ..."
  rm -rf ./.vim_runtime
fi

echo "YADR rake install..."
git clone https://github.com/amix/vimrc.git ~/.vim_runtime

sh ~/.vim_runtime/install_awesome_vimrc.sh
