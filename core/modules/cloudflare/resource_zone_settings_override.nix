
# automatically generated, you should change resource_zone_settings_override.json instead
# documentation : https://www.terraform.io/docs/providers/cloudflare/r/zone_settings_override.html
{ config, lib, ... }:
with lib;
with types;
{
  options.cloudflare.resource.zone_settings_override = mkOption {
    default = {};
    description = "";
    type = with types; attrsOf ( submodule {
      options = {
      # internal object that should not be overwritten.
      # used to generate references
      "_ref" = mkOption {
        type = with types; string;
        default = "cloudflare.zone_settings_override";
        description = "";
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
    }; });
  };

  config = mkIf config.cloudflare.enable {
    resource.cloudflare_zone_settings_override = config.cloudflare.resource.zone_settings_override;
  };

}

