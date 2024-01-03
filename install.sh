#!/bin/bash
set -euo pipefail
IFS=$'\n\t'
export PATH="$PATH:$HOME/.local/bin"
# http://redsymbol.net/articles/unofficial-bash-strict-mode/

echo "[*] Installing LaluBuntu. Go grab yourself a coffee, this will run for A WHILE. :D"
ansible-playbook -vvv -i inventory.ini --ask-become main.yml
echo "[*] Done! Logout, then you MUST pick Regolith/X11 (bottom right of sessions screen) and Login!"
echo "[🌹] Enjoy your new LaluBuntu distro!"
