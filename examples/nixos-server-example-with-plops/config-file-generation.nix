{ config, lib, pkgs, ... }:
{
  # --------------------------------------------------------------------------------
  #
  # collect all server information and generate files which get picked up
  # by plops to deploy the machines properly.
  #
  # This makes it possible to deploy VPNs like tinc and wireguard.
  #
  # --------------------------------------------------------------------------------
  resource.local_file = {
    nixosMachines = {
      content =
        with lib;
        let serverPart = name:
        ''
          ${name} = {
            host = "''${ hcloud_server.nixserver-${name}.ipv4_address }";
            user = "root";
          };
        '';
        allServerParts = map serverPart (attrNames config.hcloud.nixserver);
        in
        ''
          {
            ${concatStringsSep "\n" allServerParts}
          }
        '';
      filename = "${toString ./plops/generated/nixos-machines.nix}";
    };
    sshConfig  = {
      content =
        with lib;
        let
          configPart = name:
          ''
            Host ''${ hcloud_server.nixserver-${name}.ipv4_address }
            IdentityFile ${toString ./sshkey}
            ServerAliveInterval 60
            ServerAliveCountMax 3
          '';
        in
        concatStringsSep "\n" (map configPart (attrNames config.hcloud.nixserver));
        filename = "${toString ./plops/generated/ssh-configuration}";
    };
  };
}
