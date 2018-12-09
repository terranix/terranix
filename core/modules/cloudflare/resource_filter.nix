
# automatically generated, you should change resource_filter.json instead
# documentation : https://www.terraform.io/docs/providers/cloudflare/r/filter.html
{ config, lib, ... }:
with lib;
with types;
{
  options.cloudflare.resource.filter = mkOption {
    default = {};
    description = "";
    type = with types; attrsOf ( submodule ( { name, ... }: {
      options = {
      # internal object that should not be overwritten.
      # used to generate references
      "_ref" = mkOption {
        type = with types; string;
        default = "cloudflare_filter.${name}";
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
        description = "- (Optional) The DNS zone to which the Filter should be added. Will be resolved to upon creation.";
      };
      # automatically generated, change the json file instead
      zone_id = mkOption {
        type = nullOr string;
        default = null;
        description = "- (Optional) The DNS zone to which the Filter should be added.";
      };
      # automatically generated, change the json file instead
      paused = mkOption {
        type = nullOr string;
        default = null;
        description = "- (Optional) Whether this filter is currently paused. Boolean value.";
      };
      # automatically generated, change the json file instead
      expression = mkOption {
        type = nullOr string;
        default = null;
        description = "- (Required) The filter expression to be used.";
      };
      # automatically generated, change the json file instead
      description = mkOption {
        type = nullOr string;
        default = null;
        description = "- (Optional) A note that you can use to describe the purpose of the filter.";
      };
      # automatically generated, change the json file instead
      ref = mkOption {
        type = nullOr string;
        default = null;
        description = "- (Optional) Short reference tag to quickly select related rules.";
      };
    }; }));
  };

  config = mkIf config.cloudflare.enable {
    resource.cloudflare_filter = flip mapAttrs
      config.cloudflare.resource.filter
        (key: value:
        let
          filteredValues = filterAttrs (key: _: key != "extraConfig") value;
          extraConfig = value.extraConfig;
        in
          filteredValues // extraConfig);



  };

}

