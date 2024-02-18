#!/bin/bash
# http://redsymbol.net/articles/unofficial-bash-strict-mode/
set -euo pipefail
set -x
IFS=$'\n\t'

# The script requires sudo privileges to run
if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

# Variables
username="hacker"
groupname="hacker"

# Create a new group if it does not exist
if ! getent group "$groupname" > /dev/null 2>&1; then
    echo "Creating group: $groupname"
    groupadd "$groupname"
fi

# Create a new user and add to the group, create a home directory
if ! getent passwd "$username" > /dev/null 2>&1; then
    echo "Creating user: $username"
    useradd -m -g "$groupname" "$username"
    echo hacker:hacker | chpasswd # Tweak password/ssh_key here if needed
else
    echo "User $username already exists"
fi

# Add user to sudoers file
sudoers_file="/etc/sudoers.d/$username"
if [ ! -f "$sudoers_file" ]; then
    echo "Adding $username to sudoers"
    echo "$username ALL=(ALL) NOPASSWD: ALL" > "$sudoers_file"
    chmod 0440 "$sudoers_file"
else
    echo "User $username already has sudo privileges"
fi

echo "User $username successfully created"
