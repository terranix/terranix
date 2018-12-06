{ config, lib, ... }:

with lib;

let

  cfg = config.hetzner;

  default_token = "hetzner_hcloud_token";

in {

  options.hetzner.provider = {

    token = mkOption {
      type    = with types; string;
      default = "\${ var.${default_token} }";
      description = ''
        To get started using the API you first
        need an API token. Sign in into the Hetzner Cloud Console choose a
        project, go to Access → Tokens, and create a new token. Make sure 
        to copy the token because it won’t be shown to you again.
        A token is bound to a project, to interact with the API of another
        project you have to create a new token inside the project
      '';
    };
  };

  config = mkMerge [ 
    (mkIf cfg.enable { 
      provider."hetzner".token = cfg.provider.token;
    })
    (mkIf (cfg.enable && cfg.provider.token == "\${ var.${default_token} }") { 
      variable."${default_token}" = {
          description = ''
            This is the Hetzner Cloud API Token, can also be specified with the HCLOUD_TOKEN environment variable.
          '';
        };
      }
    )
  ];
}
