
# automatically generated, you should change resource_zone.json instead
# documentation : https://www.terraform.io/docs/providers/cloudflare/r/zone.html
{ config, lib, ... }:
with lib;
with types;
{
  options.cloudflare.resource.zone = mkOption {
    default = {};
    description = "";
    type = with types; attrsOf ( submodule ( { name, ... }: {
      options = {
      # internal object that should not be overwritten.
      # used to generate references
      "_ref" = mkOption {
        type = with types; string;
        default = "cloudflare_zone.${name}";
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
      zone = mkOption {
        type = nullOr string;
        default = null;
        description = "- (Required) The DNS zone name which will be added.";
      };
      # automatically generated, change the json file instead
      paused = mkOption {
        type = nullOr string;
        default = null;
        description = "- (Optional) Boolean of whether this zone is paused (traffic bypasses Cloudflare). Default: false.";
      };
      # automatically generated, change the json file instead
      jump_start = mkOption {
        type = nullOr string;
        default = null;
        description = "- (Optional) Boolean of whether to scan for DNS records on creation. Ignored after zone is created. Default: false.";
      };
    }; }));
  };

  config =
    let
      result = flip mapAttrs
        config.cloudflare.resource.zone
          (key: value:
          let
            filteredValues = filterAttrs (key: _: key != "extraConfig") value;
            extraConfig = value.extraConfig;
          in
            filteredValues // extraConfig);
    in
      mkIf ( config.cloudflare.enable && length (builtins.attrNames result) != 0 ) {
        resource.cloudflare_zone = result;
      };
}

