#!/bin/bash

# Usage:
# install.sh

set -e

if ! command -v cc >/dev/null; then
  echo "Installing xcode ..."
  xcode-select --install
else
  echo "Xcode already installed. Skipping."
fi

if [[ -z $(which brew) ]]; then
  echo "Installing Homebrew...";
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" > /dev/null;
fi

if [[ -z $(which ansible) ]]; then
    echo "Installing Ansible";
    brew install ansible > /dev/null;
fi

if [[ -d "/Users/${WHOAMI}/Documents/dotfiles" ]]; then
    echo "Removing dotfiles";
    rm -rf "/Users/${WHOAMI}/Documents/dotfiles" > /dev/null;
fi
if [[ -d "/Users/${WHOAMI}/.setup" ]]; then
    echo "Removing playbook";
    rm -rf "/Users/${WHOAMI}/.setup" > /dev/null;
fi

WHOAMI=$(whoami);

git clone https://github.com/kinigitbyday/mac-dev-playbook.git "/Users/${WHOAMI}/.setup" > /dev/null;
git clone https://github.com/kinigitbyday/dotfiles.git "/Users/${WHOAMI}/Documents/dotfiles" > /dev/null;

# Install YADR
if [ -d "./.yadr" ]; then
  echo "YADR repo dir exists. Removing ..."
  rm -rf ./.yadr
fi

echo "YADR rake install..."
git clone https://github.com/kinigitbyday/yadr.git ~/.yadr

cd ~/.yadr
bundle exec rake install

cd "/Users/${WHOAMI}/.setup/";

echo "Installing requirements";
ansible-galaxy install -r ./requirements.yml;

echo "Initiating playbook";

ansible-playbook ./main.yml -i inventory -K;

echo "Done.";
