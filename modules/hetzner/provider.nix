{ config, lib, ... }:

with lib;

let

  cfg = config.hetzner;

in {

  options.hetzner = {

    enable = mkEnableOption "enable hetzner.provider";

    provider.token = mkOption {
      type    = with types; string;
      default = "\${var.hcloud_token}";
      description = ''
        This is the Hetzner Cloud API Token, can also be specified with the HCLOUD_TOKEN environment variable.
      '';
    };

  };

  config = mkMerge [ 
    (mkIf cfg.enable { 
      provider = [ { 
        "hetzner".token = cfg.provider.token;
      }];
    })
    (mkIf (cfg.enable && cfg.provider.token == "\${var.hcloud_token}") { 
      variable = [ { 
        "hcloud_token" = {};
      }];
    })
  ];
}
