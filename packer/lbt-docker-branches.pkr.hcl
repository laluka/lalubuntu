packer {
  required_plugins {
    docker = {
      source  = "github.com/hashicorp/docker"
      version = ">= 1.0.9"
    }
  }
}

source "docker" "lbt" {
  changes = [
    "LABEL version=1.0",
    "ONBUILD date",
    "USER root",
    "WORKDIR /root",
    "ENTRYPOINT [\"/bin/bash\", \"-c\"]",
    "CMD -c",
  ]
}

build {
  name = "lbt-pre-install"

  source "source.docker.lbt" {
    image  = "ubuntu:24.04"
    commit = true
  }

  provisioner "file" {
    source      = "."
    destination = "/opt/lalubuntu"
  }

  provisioner "shell" {
    environment_vars = [
      "DEBIAN_FRONTEND=noninteractive",
      "TZ=Etc/UTC",
    ]
    inline = [
      "(id;date) | tee /.provisionned_by_packer",
      "apt-get update",
      "apt-get install -y curl vim git wget tzdata sudo",
      "git config --global --add safe.directory /opt/lalubuntu",
      "cd /opt/lalubuntu",
      "bash -x packer/create-user.sh",
      "echo \"hacker ALL=(ALL) NOPASSWD: ALL # TMPHACK_INSTALL_ONLY\" | tee -a /etc/sudoers",
      "su hacker -c \"bash -x pre-install.sh\"",
      "rm -rf /opt/lalubuntu",
      "sed -i /TMPHACK_INSTALL_ONLY/d /etc/sudoers", # Remove tmp hack for user rights
    ]
  }

  post-processors {
    post-processor "docker-tag" {
      repository = "thelaluka/lalubuntu"
      tags       = ["pre-install"]
    }
  }
}

build {
  name = "lbt-base-install"

  source "source.docker.lbt" {
    image  = "thelaluka/lalubuntu:pre-install"
    commit = true
    pull   = false
  }

  provisioner "file" {
    source      = "."
    destination = "/opt/lalubuntu"
  }

  provisioner "shell" {
    environment_vars = [
      "DEBIAN_FRONTEND=noninteractive",
      "TZ=Etc/UTC",
    ]
    inline = [
      "git config --global --add safe.directory /opt/lalubuntu",
      "cd /opt/lalubuntu",
      "echo \"hacker ALL=(ALL) NOPASSWD: ALL # TMPHACK_INSTALL_ONLY\" | tee -a /etc/sudoers",
      "sudo -u hacker -- bash -xlc \"ansible-playbook -v -i inventory.ini main.yml --tags base-install\"",
      "sed -i /TMPHACK_INSTALL_ONLY/d /etc/sudoers", # Remove tmp hack for user rights
    ]
  }

  post-processors {
    post-processor "docker-tag" {
      repository = "thelaluka/lalubuntu"
      tags       = ["base-install"]
    }
  }
}

build {
  name = "lbt-offensive-stuff"

  source "source.docker.lbt" {
    image  = "thelaluka/lalubuntu:base-install"
    commit = true
    pull   = false
  }

  provisioner "shell" {
    environment_vars = [
      "DEBIAN_FRONTEND=noninteractive",
      "TZ=Etc/UTC",
    ]
    inline = [
      "cd /opt/lalubuntu",
      "echo \"hacker ALL=(ALL) NOPASSWD: ALL # TMPHACK_INSTALL_ONLY\" | tee -a /etc/sudoers",
      "sudo -u hacker -- bash -xlc \"ansible-playbook -v -i inventory.ini main.yml --tags offensive-stuff\"",
      "sed -i /TMPHACK_INSTALL_ONLY/d /etc/sudoers", # Remove tmp hack for user rights
    ]
  }

  post-processors {
    post-processor "docker-tag" {
      repository = "thelaluka/lalubuntu"
      tags       = ["offensive-stuff"]
    }
  }
}

build {
  name = "lbt-gui-tools"

  source "source.docker.lbt" {
    image  = "thelaluka/lalubuntu:offensive-stuff"
    commit = true
    pull   = false
  }

  provisioner "shell" {
    environment_vars = [
      "DEBIAN_FRONTEND=noninteractive",
      "TZ=Etc/UTC",
    ]
    inline = [
      "cd /opt/lalubuntu",
      "echo \"hacker ALL=(ALL) NOPASSWD: ALL # TMPHACK_INSTALL_ONLY\" | tee -a /etc/sudoers",
      "sudo -u hacker -- bash -xlc \"ansible-playbook -v -i inventory.ini main.yml --tags gui-tools\"",
      "sed -i /TMPHACK_INSTALL_ONLY/d /etc/sudoers", # Remove tmp hack for user rights
    ]
  }
  post-processors {
    post-processor "docker-tag" {
      repository = "thelaluka/lalubuntu"
      tags       = ["gui-tools", "latest"]
    }
  }
}