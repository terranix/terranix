
# automatically generated, you should change resource_access_application.json instead
# documentation : https://www.terraform.io/docs/providers/cloudflare/r/access_application.html
{ config, lib, ... }:
with lib;
with types;
{
  options.cloudflare.resource.access_application = mkOption {
    default = {};
    description = "";
    type = with types; attrsOf ( submodule ( { name, ... }: {
      options = {
      # internal object that should not be overwritten.
      # used to generate references
      "_ref" = mkOption {
        type = with types; string;
        default = "cloudflare_access_application.${name}";
        description = "";
      };

      # automatically generated
      extraConfig = mkOption {
        type = nullOr attrs;
        default = null;
        example = { provider = "aws.route53"; };
        description = "use this option to add options not coverd by this module";
      };

      # automatically generated, change the json file instead
      zone_id = mkOption {
        type = nullOr string;
        default = null;
        description = "- (Required) The DNS zone to which the access rule should be added.";
      };
      # automatically generated, change the json file instead
      name = mkOption {
        type = nullOr string;
        default = null;
        description = "- (Required) Friendly name of the Access Application.";
      };
      # automatically generated, change the json file instead
      domain = mkOption {
        type = nullOr string;
        default = null;
        description = "- (Required) The complete URL of the asset you wish to put
Cloudflare Access in front of. Can include subdomains or paths. Or both.";
      };
      # automatically generated, change the json file instead
      session_duration = mkOption {
        type = nullOr string;
        default = null;
        description = "- (Optional) How often a user will be forced to
re-authorise. Must be one of , , , , , .";
      };
    }; }));
  };

  config =
    let
      result = flip mapAttrs
        config.cloudflare.resource.access_application
          (key: value:
          let
            filteredValues = filterAttrs (key: _: key != "extraConfig") value;
            extraConfig = value.extraConfig;
          in
            filteredValues // extraConfig);
    in
      mkIf ( config.cloudflare.enable && length (builtins.attrNames result) != 0 ) {
        resource.cloudflare_access_application = result;
      };
}

