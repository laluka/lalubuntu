#!/bin/bash
set -xeuo pipefail
IFS=$'\n\t'
# http://redsymbol.net/articles/unofficial-bash-strict-mode/

sudo apt-get update && sudo apt-get upgrade -y
sudo apt-get install -y pipx curl vim git wget
pipx install ansible-core --force
pipx ensurepath

echo -e "\nNow, run the following command:"
echo -e "source ~/.bashrc && ansible-playbook -vvv -i inventory.ini --ask-become main.yml"
echo -e "And grab yourself a coffee, this will run for A WHILE. :)"
