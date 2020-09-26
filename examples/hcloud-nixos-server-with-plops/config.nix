{ config, lib, pkgs, ... }:
let
  hcloud-modules = pkgs.fetchgit {
    url = "https://github.com/mrVanDalo/terranix-hcloud.git";
    rev = "5fa359a482892cd973dcc6ecfc607f4709f24495";
    sha256 = "0smgmdiklj98y71fmcdjsqjq8l41i66hs8msc7k4m9dpkphqk86p";
  };
in {

  imports = [ "${hcloud-modules}/default.nix" ];

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

  hcloud.export.nix = toString ./plops/generated/nixos-machines.nix;

  resource.local_file.sshConfig = {
    filename = "${toString ./plops/generated/ssh-configuration}";
    content = with lib;
      let
        configPart = name: ''
          Host ''${ hcloud_server.nixserver-${name}.ipv4_address }
          IdentityFile ${toString ./sshkey}
          ServerAliveInterval 60
          ServerAliveCountMax 3
        '';
      in concatStringsSep "\n"
      (map configPart (attrNames config.hcloud.nixserver));
  };

}
