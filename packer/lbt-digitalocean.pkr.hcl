packer {
  required_plugins {
    digitalocean = {
      version = ">= 1.3.0"
      source  = "github.com/digitalocean/digitalocean"
    }
  }
}

source "digitalocean" "src" {
  image         = "ubuntu-22-04-x64"
  region        = "ams3"
  size          = "c2-4vcpu-8gb"
  ssh_username  = "root"
  snapshot_name = "lalubuntu-24.04"
}

build {
  name = "lbt"

  source "source.digitalocean.src" {
    name = "lalubuntu"
  }

  # DEV ONLY
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
      "if command -v cloud-init; then cloud-init status --wait; fi || true",
      "(id;date) | tee /.provisionned_by_packer",
      "echo \"debconf debconf/frontend select Noninteractive\" | debconf-set-selections",
      "apt-get update",
      "apt-get install -y curl vim git wget tzdata sudo",
#      "git clone https://github.com/laluka/lalubuntu",
#      "mv lalubuntu /opt/lalubuntu",
      "cd /opt/lalubuntu",
      "bash -x packer/create-user.sh",
      "chown -R hacker:hacker /opt/lalubuntu",
      "echo \"hacker ALL=(ALL) NOPASSWD: ALL # TMPHACK_INSTALL_ONLY\" | tee -a /etc/sudoers",
      "su hacker -c \"DEBIAN_FRONTEND=noninteractive bash -x pre-install.sh\"",
      "sudo -u hacker -- bash -xlc \"ansible-playbook -vvv -i inventory.ini main.yml --tags base-install\"",
      "sudo -u hacker -- bash -xlc \"ansible-playbook -vvv -i inventory.ini main.yml --tags offensive-stuff\"",
      "sudo -u hacker -- bash -xlc \"ansible-playbook -vvv -i inventory.ini main.yml --tags gui-tools\"",
      "sed -i /TMPHACK_INSTALL_ONLY/d /etc/sudoers", # Remove tmp hack for user rights
    ]
  }
}
