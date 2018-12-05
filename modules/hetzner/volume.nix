{ config, lib, ... }:

with lib;

let

  cfg = config.hetzner;

in {

  options.hetzner.volume = mkOption {
    default = {};

    type = with types; attrsOf (submodule {
      options = {
        name = mkOption {
          type = with types; string;
          description = ''
          '';
        };

        size = mkOption {
          type = with types; int;
          description = ''
            in GB
          '';
        };

        server = mkOption {
          type   = with types; string;
          description = ''
          '';
        };
      };
    });
  };

  config = 
  mkIf cfg.enable {
    # todo surround `server` with `\${server}.id`
    resource.hcloud_volume = cfg.volume;
  };
}
