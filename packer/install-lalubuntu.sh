#!/bin/bash
# http://redsymbol.net/articles/unofficial-bash-strict-mode/
set -euo pipefail
set -x
IFS=$'\n\t'

echo "[*] Installing Requirements"
date > /.provisioned-by-packer
apt-get -o DPkg::Lock::Timeout=120 update && sleep 20 # Package Locks...
apt-get -o DPkg::Lock::Timeout=120 -y install curl wget git vim tmux pipx

echo "[*] Fetching Lalubuntu"
git clone https://github.com/laluka/lalubuntu
mv lalubuntu /opt/lalubuntu && cd /opt/lalubuntu
git checkout lalu/continuous-improvements-start-2024-02-16

echo "[*] Installing Ansible & Galaxy community.general"
pipx install ansible-core --force
pipx ensurepath
export PATH="$PATH:$HOME/.local/bin"
ansible-galaxy collection install community.general

echo "[*] Installing Lalubuntu - base-install"
ansible-playbook -vvv -i inventory.ini --ask-become main.yml --tags base-install
# echo "[*] Installing Lalubuntu - offensive-stuff"
# ansible-playbook -vvv -i inventory.ini --ask-become main.yml --tags offensive-stuff
echo "[🌹] Enjoy your new LaluBuntu distro!"