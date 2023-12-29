#!/bin/bash
set -euo pipefail
IFS=$'\n\t'
# http://redsymbol.net/articles/unofficial-bash-strict-mode/

# Navigate to the repository directory
cd /opt/lalubuntu

# Check for updates
git fetch

# Compare the local and remote versions
LOCAL=$(git rev-parse HEAD)
REMOTE=$(git rev-parse @{u})

# If updates are available, prompt the user
if [ $LOCAL != $REMOTE ]; then
    echo "Update available for lalubuntu."
    while true; do
        read -p "Would you like to update? [Y/n] " response
        case $response in
            [Yy]* ) 
                git pull
                echo "lalubuntu has been updated."
                break
                ;;
            [Nn]* ) 
                echo "Update canceled."
                exit
                ;;
            * ) 
                echo "Please answer Y or n."
                ;;
        esac
    done
fi
