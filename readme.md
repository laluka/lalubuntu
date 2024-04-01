# LaluBuntu - [![packer-docker-build](https://github.com/laluka/lalubuntu/actions/workflows/packer.yml/badge.svg?branch=master)](https://github.com/laluka/lalubuntu/actions/workflows/packer.yml)

> Prompt (OpenAI): Create a logo with an Evoli-like pokemon for a linux distro named LaluBuntu, make it cute !

<img src='screens/logo-lalubuntu.png' width='250'>

> This ansible playbook will make your machine lovely to use

## This playbook is only intended to be run in `Ubuntu 22.04`

This is my - **@TheLaluka** - own config, shared with the help & motivation of **@Fransosiche** !

- Welcome to my world, `Lower The Friction` between you and your machine!
- See this brief extract of what these scripts will allow you to do
screens/logo-lalubuntu.png

[![Global Presentation](https://img.youtube.com/vi/sZQ6FVncuNA/0.jpg)](https://www.youtube.com/watch?v=sZQ6FVncuNA)

You can watch a demonstration of what is offering labuntu by clicking the picture below :

[![Lower The Friction](https://img.youtube.com/vi/xxOVNKNs24s/0.jpg)](https://www.youtube.com/watch?v=xxOVNKNs24s)

## This video is a quick how-to

Note that:

- Around 40GB of free space is needed for a full setup
- The install time will be SIGNIFICANTLY longer for a first run

[![LaluBuntu Setup](https://img.youtube.com/vi/59T4gQICirU/0.jpg)](https://www.youtube.com/watch?v=59T4gQICirU)

## Sum-Up

The ansible playbook `main.yml` applies 4 ansible roles which are:

- roles/base-install
- roles/offensive-stuff
- roles/gui-tools
- roles/hardening

## Pre-Install, Install, Update

```bash
# Pre-install
sudo apt install -y curl wget git vim tmux # Basics
git clone https://github.com/laluka/lalubuntu
# If you plan to contribute, use: git@github.com:laluka/lalubuntu.git
sudo mv lalubuntu /opt/lalubuntu
cd /opt/lalubuntu
bash -x pre-install.sh

# Main Install
bash -x install.sh
# If anything fails, the install won't be complete (ansible StopOnFail intended behavior)
# So you'll have to fix (or commment) the failing task and re-run install.sh!

# Stay Up-To-Date
lalupdate
```

## Install Specific Roles Only

Remember that `offensive-stuff` and `gui-tools` require `base-install`

```bash
# Only shell goodies
ansible-playbook -vvv -i inventory.ini --ask-become main.yml --tags base-install
# Offensive work on a headless server -> requires base-install
ansible-playbook -vvv -i inventory.ini --ask-become main.yml --tags offensive-stuff
# Smooth term & GUI for non-offensive folks -> requires base-install
ansible-playbook -vvv -i inventory.ini --ask-become main.yml --tags gui-tools
# Do the security thingy
ansible-playbook -vvv -i inventory.ini --ask-become main.yml --tags hardening
```

## Packer - Requirements

```bash
# Installing packer with mise-en-place
mise plugin add packer
mise install packer@latest
mise use -g packer@latest
packer --version # Packer v1.10.1
```

## Packer - Docker Images

> I provide public images support only, if you want to build your own comment the "docker-push" packer post-processor!

### Usage

https://hub.docker.com/repository/docker/thelaluka/lalubuntu/general

Available Tags:
- pre-install
- base-install
- offensive-stuff
- gui-tools	& latest

```bash
# LOCAL SSH
docker run --rm -it --name lbt --entrypoint /bin/zsh -p 2222:22 -d thelaluka/lalubuntu:offensive-stuff -c 'echo "hacker:LeelooMultipass" | chpasswd && /etc/init.d/ssh start && zsh -il'
ssh -p 2222 hacker@127.0.0.1 # LeelooMultipass

# LOCAL SHELL & GUI apps
docker run --rm -it --name lbt --entrypoint /bin/zsh -u hacker -w /home/hacker -e DISPLAY -v /tmp/.X11-unix/:/tmp/.X11-unix/ --net=host --privileged -d thelaluka/lalubuntu:latest
docker exec -it lbt meld /etc/passwd /etc/group /etc/subuid # Simple 3-way visual diff
```

### Build You Own

```bash
# Build Docker Layers
export DOCK_USER=thelaluka
export DOCK_PASS=LALU_SECRET_HIHI
env | grep -F DOCK
packer init packer/lbt-docker.pkr.hcl
# COMMENT OUT ALL THE DOCKER LOGIN/PUSH LINES
grep 'post-processor "docker-push"'packer/lbt-docker.pkr.hcl
# Then build :)
PACKER_LOG=1 PACKER_LOG_PATH="/tmp/pocker-$(date).log" packer build -only="lbt-pre-install.docker.lbt" packer/lbt-docker.pkr.hcl
# docker run --rm -it --entrypoint /bin/bash -u root lalubuntu:pre-install -il
PACKER_LOG=1 PACKER_LOG_PATH="/tmp/pocker-$(date).log" packer build -only="lbt-base-install.docker.lbt" packer/lbt-docker.pkr.hcl
# docker run --rm -it --entrypoint /bin/zsh -u hacker -w /home/hacker lalubuntu:base-install -il
PACKER_LOG=1 PACKER_LOG_PATH="/tmp/pocker-$(date).log" packer build -only="lbt-offensive-stuff.docker.lbt" packer/lbt-docker.pkr.hcl
# docker run --rm -it --entrypoint /bin/zsh -u hacker -w /home/hacker lalubuntu:offensive-stuff -il
PACKER_LOG=1 PACKER_LOG_PATH="/tmp/pocker-$(date).log" packer build -only="lbt-gui-tools.docker.lbt" packer/lbt-docker.pkr.hcl
# Then refer to "Usage"
```

## Packer - Digital Ocean

> This will use your account to build the image, snapshot it, and allow easy & fast deploy, single or fleet!

```bash
# Build Digital Ocean
cd /opt/lalubuntu/packer && packer init lbt-digitalocean.pkr.hcl
# export DIGITALOCEAN_ACCESS_TOKEN=xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
PACKER_LOG=1 PACKER_LOG_PATH="/tmp/pocean-$(date).log" packer build lbt-digitalocean.pkr.hcl
# Then visit https://cloud.digitalocean.com/images/snapshots/droplets & create your droplet from the last SnapShot! :)
export DO_IP=X.X.X.X
ssh "root@$DO_IP" systemctl start nxserver.service
ssh "root@$DO_IP" passwd hacker # Set your password
# Start NoMachine & Connect with hacker:127.0.0.1:4000
# Remember to:
#  - NoMachine -> Set resolution to 1920x1080
#  - NoMachine -> Grab keyboard input (for i3 bindings)
#  - Remote -> Via settings, Set resolution to 1920x1080
# ~ Enjoyyyy ~
```

- If you just want to try it quick at no cost
  - Feel free tu use my referal link: https://m.do.co/c/8f065e035836
    - You earn 200$ credit to be used within two months
    - I (lalu) save 25$ on my next infra bill, which is nice!
    - Thank you 🌹

## Base install

Base-installs scripts will install all the needed sofware and packages

- This ansible script will first update and install a lot of needed packages. You can view all the packages in `default_packages` variable in `roles/base-install/defaults/main.yml` file
- Then, it will install and configure zsh (file is `zsh-config`)
- Then, the script will install mise (former RTX) and mise packages (`mise-all`)
- After, finishing the configuration of zsh with mise-en-place (file is `zsh-config-post-mise`)
- After that, it will setup a directory named DATA (`setup-dir`)(I used it as my work dir)
- Then, some configuration of vim will be done (`vim-default`)
- Docker and docker compose will be installed (`docker-install`)
- Using fresh rust install, the script will install several tools using cargo (`cargo-dl`)
- A lil' bit of cleanup will be made (`cleanup`)

## Offensive Stuff

Offensive stuff, as the name sounds like, will install all offensive tools (some upgrade could be made tho)

- First, the script will install some tools using golang (`golang-tooling`)
- After that, it will install some tools and wordlists from github (`wordlists-and-tools`)
- A lil' bit of cleanup will be made (`cleanup`)

## Gui tools

Some GUI software such as vscode or office will be installed

- First, it installs common GUI softwares `install-gui-tools` (wireshark, vlc, obs...) (you can find all the packages in `gui_tools_to_install` (`roles/gui-tools/defaults/main.yml`))
- Then, it will installs google chrome (`install-google-chrome`)
- Last but not least, it will download and install veracrypt (`install-veracrypt`)
- Then, install nomachine (`install-nomachine`)
- Then, install discord (`install-discord`)
- Then, install vscode (`install-vscode`)
- Then, install signal (`install-signal`)
- After, it will install and setup regolith because regolith is GOAT (`setup-regolith`)
- To finish, some cleanup ! (`cleanup`)

## Hardening

Some quick hardening will be done :

- First, some ufw (firewall) config `ufw-setup`
- Then disabling some services (vars can be found `roles/hardening/defaults/main.yml`) `disable-service`
- Install (vars can be found `roles/hardening/defaults/main.yml`) `install-secu-packages`
- To finish, some cleanup ! (`cleanup`)

> I rely on chrome for everything I can. I strongly recommend installing the extensions from `chrome-extensions.lst`

---

## Gotchas

- If you are lost, use `Mod+Shift+?` to open the bindings help panel!
- One can switch between Regolith and Gnome by logging out and picking the desired UI
  - In Gnome: Top-Right corner, then logout
  - In Regolith: CMD+SPACE, then logout

<img src='screens/demo-switch-gnome-regolith.png' width='500'>

<img src='screens/demo-gnome.png' width='500'>

<img src='screens/demo-regolith.png' width='500'>

## Changelog

- 2024/04/01
  - Updated `.github/workflows/packer.yml` to add a new GitHub Actions workflow for Packer
  - Modified aliases file: replaced `temp` alias with `tmp`, added new aliases `aptitall`, `dpkgi`, `dkill`, `paste`
  - Added `trailofbits.weaudit` extension to `vscode-extensions.lst`
  - Made multiple changes to `packer/lbt-docker.pkr.hcl`, for github-action daily builds
  - Updated `pre-install.sh` with DNS settings to use Google's servers
  - Enhanced `readme.md` with a badge for packer-docker-build and a referral link section
  - Amended `roles/base-install/defaults/main.yml` with additional packages and general cleanup (size)
  - Modified `roles/base-install/tasks/mise-all.yml` with new tasks and `zsh` commands for tool installations
  - Updated `roles/gui-tools/defaults/main.yml` with new gui tools to install, such as `dunst`
  - Altered `roles/gui-tools/tasks/install-nomachine.yml` to handle NoMachine URL extraction
  - Adjusted `roles/gui-tools/tasks/setup-regolith.yml` with new Xresources configurations
  - Updated `roles/offensive-stuff/defaults/main.yml` by modifying the lists for `go_packages`, `git_repositories`, and removing some entries
- 2024/02/28
  - Enhanced aliases file with additional aliases: sudo-alias trick, b for bat, v for nvim, p for python, and dps for docker ps
  - Modified sysdig alias in aliases for improved Docker container handling
  - In packer/create-user.sh, removed password setting for user hacker and added hacker to sudo group
  - Added new Packer configuration files lbt-digitalocean.pkr.hcl and lbt-docker.pkr.hcl for building DigitalOcean and Docker images
  - Updated pre-install.sh script with apt-get clean and package installation changes
  - Revised readme.md with detailed Packer usage instructions for Docker and DigitalOcean, including environment setup and build commands
  - Modified roles/base-install/defaults/main.yml by removing bat from default_packages and adding it to mise_tools
  - Updated roles/base-install/tasks/default-packages.yml to check for and disable Ubuntu Pro ESM spammy messages
- 2024/02/26
  - Updated `readme.md` with section "Install Specific Roles Only" with previous tag addons
  - Removed `trash-cli` from `base-install` default packages and added latest install via pipx
  - Added `meld` and `tmate` to `base-install` default packages
  - Added `duf`, `neovim`, `websocat` to `mise_tools` in `base-install`
  - Added task to disable Ubuntu Pro ESM spammy messages in `base-install`
  - Added download and executable setting tasks for `fastgron` in `base-install`
  - Included `neovim` install and config tasks in `base-install` aliased on `v`
  - Slightly reworked and unified variable use
  - Updated `gui-tools` tasks for `cameractrls` and `nomachine` with various fixes
  - Allow `nomachine` install to fail, they often make breaking changes to the install process
  - Updated `offensive-stuff` `go_packages` and `git_repositories` lists
- 2024/02/24
  - Created `.gitignore` with patterns for `lalubuntu.tar`, `*.log`, `*.pem`, `.env`
  - Added `clean-crash` alias to remove files from `/var/crash`
  - Refactored roles in `main.yml` with tags for organization (`base-install`, `offensive-stuff`, `gui-tools`, `hardening`)
  - Added user creation script `create-user.sh` for user `hacker` with temp sudo privileges for install time
  - Implemented Packer configuration `do-lalubuntu.pkr.hcl` for Docker Imge and DigitalOcean snapshot creation
  - Updated `readme.md` with TODOs, Packer instructions, and additional tools to install
  - Fixed mise sometimes not being loaded & removed xrandr unused aliases
  - Implemented security measures and cleanup in Packer build process
- 2024/01/12
  - Added a new alias: `yt-dlp`
  - Updated `readme.md` with `TODO` section
  - Created `vscode-extensions.lst` for VS Code extensions
  - Added auto completion for a few kube/terraform related tools
  - Added gnome-tweaks, blueman, obs-studio from the official ppa
  - Added lalutools pty4all, pypotomux, broneypote, bypass-url-parser
  - Added bindsym for sound settings
- 2024/01/06
  - Renamed `rtx` to `mise-en-place`
  - Added a changelog section to `readme.md`

## TODO

```bash
# None for now :)
```
