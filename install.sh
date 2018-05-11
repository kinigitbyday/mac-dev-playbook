#!/bin/bash

# Usage:
# install.sh

fancy_echo() {
  local fmt="$1"; shift

  # shellcheck disable=SC2059
  printf "\n$fmt\n" "$@"
}

trap 'ret=$?; test $ret -ne 0 && printf "failed\n\n" >&2; exit $ret' EXIT

set -e

if ! command -v cc >/dev/null; then
  fancy_echo "Installing xcode ..."
  xcode-select --install
else
  fancy_echo "Xcode already installed. Skipping."
fi

if [[ -z $(which brew) ]]; then
  fancy_echo "Installing Homebrew...";
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" > /dev/null;
fi

if [[ -z $(which ansible) ]]; then
    fancy_echo "Installing Ansible";
    brew install ansible > /dev/null;
fi

if [[ -d "/Users/${WHOAMI}/Documents/dotfiles" ]]; then
    fancy_echo "Removing dotfiles";
    rm -rf "/Users/${WHOAMI}/Documents/dotfiles" > /dev/null;
fi
if [[ -d "/Users/${WHOAMI}/.setup" ]]; then
    fancy_echo "Removing playbook";
    rm -rf "/Users/${WHOAMI}/.setup" > /dev/null;
fi

WHOAMI=$(whoami);

git clone https://github.com/kinigitbyday/mac-dev-playbook.git "/Users/${WHOAMI}/.setup" > /dev/null;
git clone https://github.com/kinigitbyday/dotfiles.git "/Users/${WHOAMI}/Documents/dotfiles" > /dev/null;

# Install YADR
if [ -d "./.yadr" ]; then
  fancy_echo "YADR repo dir exists. Removing ..."
  rm -rf ./.yadr
fi

fancy_echo "YADR rake install..."
git clone https://github.com/skwp/dotfiles.git ~/.yadr

if [ -e ~/Library/Preferences/com.googlecode.iterm2.plist ]; then
  fancy_echo "Backing up iTerm2 plist to prevent yadr from requiring input"
  mv ~/Library/Preferences/com.googlecode.iterm2.plist ~/Library/Preferences/com.googlecode.iterm2.plist.bak
fi

cd ~/.yadr
rake install

if [ -e ~/Library/Preferences/com.googlecode.iterm2.plist.bak ]; then
  fancy_echo "Restoring iTerm2 plist"
  mv ~/Library/Preferences/com.googlecode.iterm2.plist.bak ~/Library/Preferences/com.googlecode.iterm2.plist
fi

cd "/Users/${WHOAMI}/.setup/";

echo "Installing requirements";
ansible-galaxy install -r ./requirements.yml;

echo "Initiating playbook";

ansible-playbook ./main.yml -i inventory -K;

echo "Done.";
