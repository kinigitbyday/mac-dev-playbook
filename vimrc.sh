#!/bin/bash

# Install YADR
if [ -d "./.vim_runtime" ]; then
  echo "vim_runtime repo dir exists. Removing ..."
  rm -rf ./.vim_runtime
fi

echo "vim_runtime install..."
git clone https://github.com/amix/vimrc.git ~/.vim_runtime

sh ~/.vim_runtime/install_awesome_vimrc.sh
