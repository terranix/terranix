{ lib, pkgs, ... }:
let
  hcloud-modules = pkgs.fetchgit {
    url = "https://github.com/mrVanDalo/terranix-hcloud.git";
    rev = "c3571f76664e1813f90d97b8c194a1e0149e895e";
    sha256 = "0plld74wincyy3c5gdfqh78pzrqibxh6r839dm0c717fajr9imwb";
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

  hcloud.export.nix = null;

}
