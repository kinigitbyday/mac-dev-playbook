!#/bin/bash

if ! command -v cc >/dev/null; then
  echo "Installing xcode ..."
  xcode-select --install
else
  echo "Xcode already installed. Skipping."
fi

if [[ -z $(which brew) ]]; then
  echo "Installing Homebrew...";
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)";
fi

if [[ -z $(which ansible) ]]; then
    echo "Installing Ansible";
    brew install ansible;
fi

if [[ -d ~/.dotfiles ]]; then
    echo "Updating dotfiles";
    cd ~/.dotfiles;
    git pull origin master;
else 
  echo "Cloning dotfiles"
  git clone https://github.com/kinigitbyday/dotfiles.git ~/.dotfiles > /dev/null;
fi
if [[ -d ~/.setup ]]; then
    echo "Updating playbook";
    cd ~/.setup;
    git pull origin master;
else 
  "Cloning playbook"
  git clone https://github.com/kinigitbyday/mac-dev-playbook.git ~/.setup > /dev/null;
fi

cd ~/.setup/;

echo "Installing requirements";
ansible-galaxy install -r ./requirements.yml;

echo "Initiating playbook";

ansible-playbook ./main.yml -i inventory -K;

echo "Done.";
