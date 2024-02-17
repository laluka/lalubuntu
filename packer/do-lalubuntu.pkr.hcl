packer {
  required_plugins {
    digitalocean = {
      version = ">= 1.3.0"
      source  = "github.com/digitalocean/digitalocean"
    }
  }
}

source "digitalocean" "lalubuntu" {
  image               = "ubuntu-22-04-x64"
  region              = "nyc3"
  size                = "c2-4vcpu-8gb"
  ssh_username        = "root"
  snapshot_name       = "lalubuntu-22.04"
}

build {
  sources = ["source.digitalocean.lalubuntu"]
  provisioner "shell" {
    script = "install-lalubuntu.sh"
  }
  // provisioner "file" {
    // source      = "foo.png"
    // destination = "/foo.png"
  // }
  // provisioner "shell" {
  //   inline = [
  //     "rm /etc/sudoers.d/hacker",
  //   ]
  // }
}
