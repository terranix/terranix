{ config, lib, ... }:

with lib;

let

  cfg = config.hcloud;

  default_token = "hcloud_api_token";

in {

  options.hcloud = {
    enable = mkEnableOption "enable hcloud provider";

    provider = mkOption {
      default = { token = "\${ var.${default_token} }"; };
      type = with types; (submodule {
        options = {
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
          endpoint = mkOption {
            default = null;
            type    = with types; nullOr string;
            description = ''
              - (Optional, string) Hetzner Cloud API endpoint, can be used to override the default API Endpoint https://api.hetzner.cloud/v1.
            '';
          };
          poll_interval = mkOption {
            default = null;
            type    = with types; nullOr string;
            description = ''
              - (Optional, string) Configures the interval in which actions are polled by the client. Default 500ms. Increase this interval if you run into rate limiting errors.
            '';
          };

        };
      });
    };
  };

  config = mkMerge [

    (mkIf cfg.enable {
      provider.hcloud = cfg.provider;
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
