{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.servers.grafana;

in {

  options.servers.grafana = mkOption {
    default = {};
    type = with types; attrsOf (submodule ({ name, ... }: {
      options = {
        name = mkOption {
          default = "grafana-${name}";
          type = with types; str;
          description = ''
            name
          '';
        };
      };
    }));
  };

  config =
    mkIf (cfg != {} ) (
      mkMerge [
        { resource.hcloud_server =
            let
              allResources = mapAttrs' ( name: configuration: {
                name = "grafana_${name}";
                value = {
                  name = configuration.name;
                  image  = "ubuntu-18.04";
                  server_type = "cx11";
                  user_data = ''
                    apt-get update
                    apt-get intstall docker
                  '';
                  backups = false;
                };
              }) cfg;
            in
              allResources;
        }
        { hcloud.enable = true; }
      ]
    );
}
