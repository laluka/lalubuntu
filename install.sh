#!/bin/bash
set -euo pipefail
IFS=$'\n\t'
export PATH="$PATH:$HOME/.local/bin"
# http://redsymbol.net/articles/unofficial-bash-strict-mode/

if [[ ! $(grep -F 24.04 /etc/issue.net -c) -eq 1 ]] ; then 
    echo "Lalubuntu latest has been tested on Ubuntu 24.04 only."
    echo "Please install Ubuntu 24.04 or attempt install at your own risks"
    exit 42
fi

echo "[*] Installing LaluBuntu. Go grab yourself a coffee, this will run for A WHILE. :D"
ansible-playbook -vvv -i inventory.ini --ask-become main.yml
echo "[*] Done! Logout, then you MUST pick Regolith/X11 (bottom right of sessions screen) and Login!"
echo "[*] Do take the time to visit chrome-extensions.lst for extra goodies once you're in regolith!"
echo "[🌹] Enjoy your new LaluBuntu distro!"
