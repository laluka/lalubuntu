packer {
  required_plugins {
    // digitalocean = {
    //   version = ">= 1.3.0"
    //   source  = "github.com/digitalocean/digitalocean"
    // }
    docker = {
      source  = "github.com/hashicorp/docker"
      version = ">= 1.0.9"
    }
  }
}

source "digitalocean" "lalubuntu" {
  image         = "ubuntu-22-04-x64"
  region        = "ams3"
  size          = "c2-4vcpu-8gb"
  ssh_username  = "root"
  snapshot_name = "lalubuntu-22.04"
}

source "docker" "lalubuntu" {
  image = "ubuntu:22.04"
  // export_path = "lalubuntu.tar"
  commit = true
  changes = [
    "LABEL version=1.0",
    "ONBUILD date",
    "USER hacker",
    "WORKDIR /home/hacker",
    "ENTRYPOINT /usr/bin/zsh -l",
  ]
}

build {
  name = "lbt"

  source "source.docker.lalubuntu" {
    name = "docker.lalubuntu"
  }
  source "source.digitalocean.lalubuntu" {
    name = "digitalocean.lalubuntu"
  }

  provisioner "shell" {
    only = ["*digitalocean*"]
    inline = [
      "cloud-init status --wait",
    ]
  }
  provisioner "shell" {
    environment_vars = [
      "DEBIAN_FRONTEND=noninteractive",
      "TZ=Etc/UTC",
    ]
    // except = ["*digitalocean*"] # Provisioner option to dodge a task
    inline = [
      "id",
      // "if command -v cloud-init; then systemctl stop cloud-init.service; fi",
      // "alias waitaptget='while pgrep apt-get; do echo \"Waiting for apt-get to release lock\"; sleep 1; done'",
      // "if command -v cloud-init; then systemctl stop cloud-init.service; fi"
      // "if command -v cloud-init; then cloud-init status --wait; fi",
      // "cloud-init status --wait || true",
      // "waitaptget",
      "apt-get update",
      // "waitaptget",
      "apt-get upgrade -y",
      // "waitaptget",
      "apt-get install -y curl wget git vim tmux sudo tzdata",
      // "waitaptget",
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
      "rm -rf /var/lib/apt/lists/*",
      "apt-get update",
      "sudo -u hacker -- bash -l -c \"ansible-playbook -vvv -i inventory.ini main.yml --tags base-install\"",
      // "ansible-playbook -vvv -i inventory.ini main.yml --tags offensive-stuff",
      "sed -i \"/TMPHACK_INSTALL_ONLY/d\" /etc/sudoers", # Remove tmp hack for user rights
    ]
  }
}