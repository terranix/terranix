{ config, lib, pkgs, ...}:
{

  imports = [
    ./modules
    ./config-file-generation.nix
  ];

  # configure admin ssh keys
  users.admins.palo.publicKey = "${lib.fileContents ./sshkey.pub}";

  # configure provisioning private Key to be used when running provisioning on the machines
  provisioner.privateKeyFile = toString ./sshkey;

  hcloud.nixserver = {
    server1 = {
      enable = true;
      configurationFile = pkgs.writeText "configuration.nix" ''
        { pkgs, lib, config, ... }:
        {
          environment.systemPackages = [ pkgs.git ];
        }
      '';
    };
  };

}
