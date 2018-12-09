
# automatically generated, you should change resource_custom_pages.json instead
# documentation : https://www.terraform.io/docs/providers/cloudflare/r/custom_pages.html
{ config, lib, ... }:
with lib;
with types;
{
  options.cloudflare.resource.custom_pages = mkOption {
    default = {};
    description = "";
    type = with types; attrsOf ( submodule ( { name, ... }: {
      options = {
      # internal object that should not be overwritten.
      # used to generate references
      "_ref" = mkOption {
        type = with types; string;
        default = "cloudflare_custom_pages.${name}";
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
        description = "- (Optional) The zone ID where the custom pages should be
updated. Either or must be provided.";
      };
      # automatically generated, change the json file instead
      account_id = mkOption {
        type = nullOr string;
        default = null;
        description = "- (Optional) The account ID where the custom pages should be
updated. Either or must be provided. If is present, it will override the zone setting.";
      };
      # automatically generated, change the json file instead
      type = mkOption {
        type = nullOr string;
        default = null;
        description = "- (Required) The type of custom page you wish to update. Must
be one of , , , , , , , , , .";
      };
      # automatically generated, change the json file instead
      url = mkOption {
        type = nullOr string;
        default = null;
        description = "- (Required) URL of where the custom page source is located.";
      };
      # automatically generated, change the json file instead
      state = mkOption {
        type = nullOr string;
        default = null;
        description = "- (Required) Managed state of the custom page. Must be one of , . If the value is it will be removed
from the Terraform state management.";
      };
    }; }));
  };

  config =
    let
      result = flip mapAttrs
        config.cloudflare.resource.custom_pages
          (key: value:
          let
            filteredValues = filterAttrs (key: _: key != "extraConfig") value;
            extraConfig = value.extraConfig;
          in
            filteredValues // extraConfig);
    in
      mkIf ( config.cloudflare.enable && length (builtins.attrNames result) != 0 ) {
        resource.cloudflare_custom_pages = result;
      };
}

