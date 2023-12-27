#!/bin/bash
set -euo pipefail
IFS=$'\n\t'
# http://redsymbol.net/articles/unofficial-bash-strict-mode/

echo "[*] Installing linux basics"
sudo apt-get update && sudo apt-get upgrade -y
sudo apt-get install -y pipx curl vim git wget

echo "[*] Installing Pipx & Ansible"
pipx install ansible-core --force
pipx ensurepath

echo "[*] Installing Ansible Galaxy Collections"
source ~/.bashrc
pipx run ansible-galaxy collection install community.general
echo "[*] Installing LaluBuntu. Go grab yourself a coffee, this will run for A WHILE. :D"
pipx run ansible-playbook -vvv -i inventory.ini --ask-become main.yml
echo "[*] Done! Logout, then you MUST pick Regolith/X11 (bottom right of sessions screen) and Login!"
echo "[🌹] Enjoy your new LaluBuntu distro!"
