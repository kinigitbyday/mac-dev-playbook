!#/bin/bash

if ! command -v cc >/dev/null; then
  echo "Installing xcode ..."
  xcode-select --install
else
  echo "Xcode already installed. Skipping."
fi

if [[ -z $(which brew) ]]; then
  echo "Installing Homebrew...";
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)";
fi

if [[ -z $(which ansible) ]]; then
    echo "Installing Ansible";
    brew install ansible;
fi

if [[ -d ~/Documents/dotfiles ]]; then
    echo "Removing dotfiles";
    rm -rf ~/Documents/dotfiles;
fi
if [[ -d ~/.setup ]]; then
    echo "Removing playbook";
    rm -rf ~/.setup;
fi

git clone https://github.com/kinigitbyday/mac-dev-playbook.git ~/.setup > /dev/null;
git clone https://github.com/kinigitbyday/dotfiles.git ~/Documents/dotfiles > /dev/null;

cd ~/.setup/;

echo "Setting up vimrc (https://github.com/axim/vimrc)"
bash ./vimrc.sh

echo "Running playbook"
bash ./playbook.sh

echo "Done!"
