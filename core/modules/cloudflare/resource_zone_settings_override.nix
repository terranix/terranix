
# automatically generated, you should change resource_zone_settings_override.json instead
# documentation : https://www.terraform.io/docs/providers/cloudflare/r/zone_settings_override.html
{ config, lib, ... }:
with lib;
with types;
{
  options.cloudflare.resource.zone_settings_override = mkOption {
    default = {};
    description = "";
    type = with types; attrsOf ( submodule ( { name, ... }: {
      options = {
      # internal object that should not be overwritten.
      # used to generate references
      "_ref" = mkOption {
        type = with types; string;
        default = "cloudflare_zone_settings_override.${name}";
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
      name = mkOption {
        type = nullOr string;
        default = null;
        description = "- (Required) The DNS zone to which apply settings.";
      };
      # automatically generated, change the json file instead
      settings = mkOption {
        type = nullOr string;
        default = null;
        description = "- (Optional) Settings overrides that will be applied to the zone. If a setting is not specified the existing setting will be used. For a full list of available settings see below.";
      };
    }; }));
  };

  config =
    let
      result = flip mapAttrs
        config.cloudflare.resource.zone_settings_override
          (key: value:
          let
            filteredValues = filterAttrs (key: _: key != "extraConfig") value;
            extraConfig = value.extraConfig;
          in
            filteredValues // extraConfig);
    in
      mkIf ( config.cloudflare.enable && length (builtins.attrNames result) != 0 ) {
        resource.cloudflare_zone_settings_override = result;
      };
}

