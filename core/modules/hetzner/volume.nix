{ config, lib, ... }:

with lib;

let

  cfg = config.hetzner;

in {

  options.hetzner.volume = mkOption {
    default = {};

    type = with types; attrsOf (submodule ( {name, ... }: {
      options = {
        "_ref" = mkOption {
          type = with types; string;
          default = "hcloud_volume.${name}";
          description = ''
            internal object that should not be overwritten.
            used to generate references
          '';
        };
        name = mkOption {
          type = with types; string;
          description = ''
            Name of the volume to create (must be unique per project).
          '';
        };
        size = mkOption {
          type = with types; int;
          description = ''
            Size of the volume (in GB).
          '';
        };
        server = mkOption {
          type   = with types; nullOr string;
          default = null;
          description = ''
            Server to attach the Volume to, optional if location argument is passed.
          '';
        };
        location = mkOption {
          type    = with types; nullOr string;
          default = null;
          description = ''
            Location of the volume to create, optional if server_id argument is passed.
          '';
        };
      };
    }));
  };

  config = mkIf cfg.enable {
    resource.hcloud_volume = cfg.volume;
  };

}
