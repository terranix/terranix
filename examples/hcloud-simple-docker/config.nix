{ lib, pkgs, ... }:
let
  hcloud-modules = pkgs.fetchgit {
    url = "https://github.com/mrVanDalo/terranix-hcloud.git";
    rev = "5fa359a482892cd973dcc6ecfc607f4709f24495";
    sha256 = "0smgmdiklj98y71fmcdjsqjq8l41i66hs8msc7k4m9dpkphqk86p";
  };
in {

  imports = [ "${hcloud-modules}/default.nix" ./modules/grafana.nix ];

  # configure admin ssh keys
  users.admins.palo.publicKey = "${lib.fileContents (toString ./sshkey.pub)}";
  # configure provisioning private Key to be used when running provisioning on the machines
  provisioner.privateKeyFile = toString ./sshkey;

  # install a grafana examples server (from example modules)
  servers.grafana = {
    enable = true;
    plugins = [ "grafana-worldmap-panel" ];
  };

}
