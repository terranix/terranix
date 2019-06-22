{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.hcloud.nixserver;

  nixosInfect = pkgs.fetchgit {
    "url" = "https://github.com/elitak/nixos-infect.git";
    "rev" = "6c6e63594dd831a9b0177add82c84a4ebbd6f7af";
    "sha256" = "0817x7fzqlbbajy1wvkbd9i7mzm2lfzm45w15pc4mbag44bjc0vi";
  };

in {


  options.hcloud.nixserver = mkOption {
    default = {};
    type = with types; attrsOf (submodule ({ name, ... }: {
      options = {
        enable = mkEnableOption "nixserver";

        # todo eine option für zusätzlichen speicher
        name = mkOption {
          default = "nixserver-${name}";
          type = with types; str;
          description = ''
            name of the server running nixos
          '';
        };
        serverType = mkOption {
          default = "cx11";
          type = with types; str;
          description = ''
            server type (different costs)
          '';
        };
        channel = mkOption {
          default = "nixos-19.03";
          type = with types; str;
          description = ''
            nixos channel to install
          '';
        };
        backups = mkOption {
          default = false;
          type = with types; bool;
          description = ''
            enable backups or not
          '';
        };
        configurationFile = mkOption {
          default = null;
          type = with types; nullOr path;
          description = ''
            additional configuration File
          '';
        };
        provisioners = mkOption {
          default = [];
          type = with types; listOf attrs;
        };
      };
    }));
  };

  config = mkIf (cfg != {}){

    hcloud.server = mapAttrs' (
      name: configuration:
      {
        name = "${configuration.name}";
        value = {
          inherit (configuration) enable serverType backups name;
          provisioners = [
            {
              file.source = "${nixosInfect}/nixos-infect";
              file.destination = "/root/nixos-infect";
            }
            (
              optionalAttrs
              (configuration.configurationFile != null)
              {
                file.source = configuration.configurationFile;
                file.destination = "/etc/nixos_input.nix";
              }
            )
          ]
          ++ configuration.provisioners ++
          [
            {
              remote-exec.inline = [
                ''
                  NO_REBOOT="dont" \
                  PROVIDER=HCloud \
                  NIX_CHANNEL=${configuration.channel} \
                  ${
                    optionalString
                    (configuration.configurationFile != null)
                    "NIXOS_IMPORT=/etc/nixos_input.nix"
                  } \
                  bash /root/nixos-infect 2>&1 | tee /tmp/infect.log
                ''
                ''shutdown -r +1''
              ];
            }
          ];
        };
      }
    ) cfg;
  };

}
