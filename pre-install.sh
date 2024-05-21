#!/bin/bash
set -euo pipefail
IFS=$'\n\t'
# http://redsymbol.net/articles/unofficial-bash-strict-mode/

echo "[*] Setting DNS to google for stability"
echo "nameserver 8.8.8.8" | sudo tee /etc/resolv.conf

echo "[*] Installing linux basics"
sudo apt-get clean
sudo apt-get update
sudo apt-get upgrade -y
sudo apt-get install -y pipx curl vim git wget tzdata sudo tmux

echo "[*] Installing Pipx & Ansible"
# tmp hardcode version as latest 2.13 for python 3.8 is buggy for "Set Wireshark to install non-interactively"
# Remove hardcoded version to live in latest (daily tests) late june
pipx install ansible-core==2.13.12 --force
pipx ensurepath
export PATH="$PATH:$HOME/.local/bin"

echo "[*] Installing Ansible Galaxy Collections"
ansible-galaxy collection install community.general
echo "[*] All good, now run:"
echo "bash -x install.sh"
