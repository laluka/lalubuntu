packer {
  required_plugins {
    digitalocean = {
      version = ">= 1.3.0"
      source  = "github.com/digitalocean/digitalocean"
    }
    docker = {
      source  = "github.com/hashicorp/docker"
      version = ">= 1.0.9"
    }
  }
}

source "digitalocean" "src" {
  image         = "ubuntu-22-04-x64"
  region        = "ams3"
  size          = "c2-4vcpu-8gb"
  ssh_username  = "root"
  snapshot_name = "lalubuntu-22.04"
}

source "docker" "src" {
  image = "ubuntu:22.04"
  // export_path = "lalubuntu.tar"
  commit = true
  changes = [
    "LABEL version=1.0",
    "ONBUILD date",
    "USER hacker",
    "WORKDIR /home/hacker",
    // "CMD /usr/bin/zsh -l",
    // "ENTRYPOINT /usr/bin/zsh -l",
  ]
}

build {
  name = "lbt"

  source "source.docker.src" {
    name = "lalubuntu"
  }
  source "source.digitalocean.src" {
    name = "lalubuntu"
  }

  provisioner "shell" {
    environment_vars = [
      "DEBIAN_FRONTEND=noninteractive",
      "TZ=Etc/UTC",
    ]
    inline = [
      "if command -v cloud-init; then cloud-init status --wait; fi",
      "(id;date) | tee /.provisionned_by_packer",
      // "apt-get clean -y"
      // "apt-get -f install",
      "echo 00; while sudo fuser /var/{lib/{dpkg,apt/lists},cache/apt/archives}/lock >/dev/null 2>&1; do echo Waiting for lock files. ; sleep 1; done",
      "echo 01; rm -rf /var/lib/apt/lists/*",
      "echo 02; apt-get update && sleep 3",
      "echo 03; while sudo fuser /var/{lib/{dpkg,apt/lists},cache/apt/archives}/lock >/dev/null 2>&1; do echo Waiting for lock files. ; sleep 1; done",
      "echo 04; apt-get upgrade -y",
      "echo 05; while sudo fuser /var/{lib/{dpkg,apt/lists},cache/apt/archives}/lock >/dev/null 2>&1; do echo Waiting for lock files. ; sleep 1; done",
      "echo 06; apt-get install -y curl wget git vim tmux sudo tzdata",
      "echo 07; while sudo fuser /var/{lib/{dpkg,apt/lists},cache/apt/archives}/lock >/dev/null 2>&1; do echo Waiting for lock files. ; sleep 1; done",
    ]
  }
  provisioner "file" {
    source      = "/opt/lalubuntu"
    destination = "/opt/lalubuntu"
  }
  provisioner "shell" {
    environment_vars = [
      "DEBIAN_FRONTEND=noninteractive",
      "TZ=Etc/UTC",
    ]
    inline = [
      // "git clone https://github.com/laluka/lalubuntu",
      // "mv lalubuntu /opt/lalubuntu",
      "cd /opt/lalubuntu",
      "bash -x packer/create-user.sh",
      "sudo -u hacker -- bash -x pre-install.sh",
      "while sudo fuser /var/{lib/{dpkg,apt/lists},cache/apt/archives}/lock >/dev/null 2>&1; do echo Waiting for lock files. ; sleep 1; done",
      "apt-get update",
      "while sudo fuser /var/{lib/{dpkg,apt/lists},cache/apt/archives}/lock >/dev/null 2>&1; do echo Waiting for lock files. ; sleep 1; done",
      "sudo -u hacker -- bash -l -c \"ansible-playbook -vvv -i inventory.ini main.yml --tags base-install\"",
      // "ansible-playbook -vvv -i inventory.ini main.yml --tags offensive-stuff",
      "sed -i \"/TMPHACK_INSTALL_ONLY/d\" /etc/sudoers", # Remove tmp hack for user rights
    ]
  }
}