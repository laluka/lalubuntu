packer {
  required_plugins {
    docker = {
      source  = "github.com/hashicorp/docker"
      version = ">= 1.0.9"
    }
  }
}

source "docker" "lbt" {
  commit = true
  changes = [
    "LABEL version=1.0",
    "ONBUILD date",
    "USER root",
    "WORKDIR /root",
    "ENTRYPOINT /bin/bash",
    "CMD -c",
  ]
}

build {
  name = "lbt-pre-install"

  source "source.docker.lbt" {
    image = "ubuntu:22.04"
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
      "(id;date) | tee /.provisionned_by_packer",
      "cd /opt/lalubuntu",
      "apt-get update",
      "apt-get install -y curl vim git wget tzdata sudo",
      "bash -x packer/create-user.sh",
      "echo \"hacker ALL=(ALL) NOPASSWD: ALL # TMPHACK_INSTALL_ONLY\" | tee -a /etc/sudoers",
      "su hacker -c \"bash -x pre-install.sh\"",
      "rm -rf /opt/lalubuntu",
      "sed -i /TMPHACK_INSTALL_ONLY/d /etc/sudoers", # Remove tmp hack for user rights
    ]
  }

  post-processor "docker-tag" {
    repository = "lalubuntu"
    tag = ["pre-install"]
  }

  post-processor "manifest" {
    output = "lbt-pre-install-manifest.json"
    strip_path = true
  }
}

build {
  name = "lbt-base-install"

  source "source.docker.lbt" {
    image = "lalubuntu:pre-install"
    pull = false
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
      "cd /opt/lalubuntu",
      "echo \"hacker ALL=(ALL) NOPASSWD: ALL # TMPHACK_INSTALL_ONLY\" | tee -a /etc/sudoers",
      "sudo -u hacker -- bash -xlc \"ansible-playbook -vvv -i inventory.ini main.yml --tags base-install\"",
      "sed -i /TMPHACK_INSTALL_ONLY/d /etc/sudoers", # Remove tmp hack for user rights
    ]
  }

  post-processor "docker-tag" {
    repository = "lalubuntu"
    tag = ["base-install"]
  }

  post-processor "manifest" {
    output = "lbt-base-install-manifest.json"
    strip_path = true
  }
}

# build {
#   name = "lbt-offensive-stuff"

#   source "source.docker.lbt" {
#     image = "lalubuntu:base-install"
#     pull = false
#   }

#   provisioner "shell" {
#     environment_vars = [
#       "DEBIAN_FRONTEND=noninteractive",
#       "TZ=Etc/UTC",
#     ]
#     inline = [
#       "cd /opt/lalubuntu",
#       "echo \"$username ALL=(ALL) NOPASSWD: ALL # TMPHACK_INSTALL_ONLY\" | tee -a /etc/sudoers",
#       "sudo -u hacker -- bash -xc \"ansible-playbook -vvv -i inventory.ini main.yml --tags offensive-stuff\"",
#       "sed -i /TMPHACK_INSTALL_ONLY/d /etc/sudoers", # Remove tmp hack for user rights
#     ]
#   }

#   post-processor "docker-tag" {
#     repository = "lalubuntu"
#     tag = ["offensive-stuff"]
#   }

#   post-processor "manifest" {
#     output = "lbt-offensive-stuff-manifest.json"
#     strip_path = true
#   }
# }