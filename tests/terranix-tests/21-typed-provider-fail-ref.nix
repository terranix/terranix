{ config, lib, ... }:

{
  imports = [ (lib.tf.provider "hetznercloud_hcloud") ];

  resource.hcloud_ssh_key.key = {
    name = "key";
    public_key = "ssh-ed25519 AAAA";
  };

  resource.hcloud_server.web = {
    name = "web";
    server_type = "cx23";
    ssh_keys = [ (config.resource.hcloud_ssh_key.key "id") ];
    # a single block is wrapped in a list for set blocks
    public_net.ipv4_enabled = true;
  };

  output.ip.value = config.resource.hcloud_server.web "ipv4_adress";
}
