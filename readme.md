# LaluBuntu

> Prompt (OpenAI): Create a logo with an Evoli-like pokemon for a linux distro named LaluBuntu, make it cute !

<img src='screens/logo-lalubuntu.png' width='250'>

> This ansible playbook will make your machine lovely to use.

## This playbook is only intended to be run in `Ubuntu 22.04`

This is my - **@TheLaluka** - own config, shared with the help & motivation of **@Fransosiche** !

- Welcome to my world, `Lower The Friction` between you and your machine!
- See this brief extract of what these scripts will allow you to do
screens/logo-lalubuntu.png

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
# If you ARE A DEV and PLAN TO CONTRIBUTE
# git clone git@github.com:laluka/lalubuntu.git
sudo apt install -y curl wget git vim tmux # Basics
git clone https://github.com/laluka/lalubuntu
sudo mv lalubuntu /opt/lalubuntu
cd /opt/lalubuntu
bash -x pre-install.sh
bash -x install.sh
# Update with
lalupdate
```

## Base install

Base-installs scripts will install all the needed sofware and packages.

- This ansible script will first update and install a lot of needed packages. You can view all the packages in `default_packages` variable in `roles/base-install/defaults/main.yml` file
- Then, it will install and configure zsh (file is `zsh-config`)
- Then, the script will install rtx and rtx packages (`rtx-all`)
- After, finishing the configuration of zsh with RTX(file is `zsh-config-post-rtx`)
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

- One can switch between Regolith and Gnome by logging out and picking the desired UI
  - In Gnome: Top-Right corner, then logout
  - In Regolith: CMD+SPACE, then logout

<img src='screens/demo-switch-gnome-regolith.png' width='500'>

<img src='screens/demo-gnome.png' width='500'>

<img src='screens/demo-regolith.png' width='500'>
