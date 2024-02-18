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

// source "digitalocean" "lalubuntu" {
//   image               = "ubuntu-22-04-x64"
//   region              = "ams3"
//   size                = "c2-4vcpu-8gb"
//   ssh_username        = "root"
//   snapshot_name       = "lalubuntu-22.04"
// }

source "docker" "lalubuntu" {
  image = "ubuntu:22.04"
  // export_path = "lalubuntu.tar"
  commit = true
  changes = [
    "ENTRYPOINT /bin/bash"
  ]
}

build {
  sources = ["source.docker.lalubuntu"]
  provisioner "shell" {
    script = "install-lalubuntu.sh"
  }
}

// build {
//   sources = ["source.digitalocean.lalubuntu"]
//   provisioner "shell" {
//     script = "install-lalubuntu.sh"
//   }
//   // provisioner "file" {
//     // source      = "foo.png"
//     // destination = "/foo.png"
//   // }
//   // provisioner "shell" {
//   //   inline = [
//   //     "rm /etc/sudoers.d/hacker",
//   //   ]
//   // }
// }
