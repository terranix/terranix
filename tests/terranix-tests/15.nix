{ lib, pkgs, ... }:
{
  resource.hcloud_ssh_key.my_key = {
    name       = "my-ssh-key";
    public_key = lib.tf.file "~/.ssh/id_ed25519.pub";
  };
}
