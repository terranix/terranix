
# automatically generated, you should change resource_zone_lockdown.json instead
# documentation : https://www.terraform.io/docs/providers/cloudflare/r/zone_lockdown.html
{ config, lib, ... }:
with lib;
with types;
{
  options.cloudflare.resource.zone_lockdown = mkOption {
    default = {};
    description = "";
    type = with types; attrsOf ( submodule ( { name, ... }: {
      options = {
      # internal object that should not be overwritten.
      # used to generate references
      "_ref" = mkOption {
        type = with types; string;
        default = "cloudflare_zone_lockdown.${name}";
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
        type = string;
        
        description = "- The DNS zone to which the lockdown will be added. Will be resolved to upon creation.";
      };
      # automatically generated, change the json file instead
      zone_id = mkOption {
        type = string;
        
        description = "- The DNS zone to which the access rule should be added.";
      };
      # automatically generated, change the json file instead
      description = mkOption {
        type = nullOr string;
        default = null;
        description = "- (Optional) A description about the lockdown entry. Typically used as a reminder or explanation for the lockdown.";
      };
      # automatically generated, change the json file instead
      urls = mkOption {
        type = listOf string;
        
        description = "- (Required) A list of simple wildcard patterns to match requests against. The order of the urls is unimportant.";
      };
      # automatically generated, change the json file instead
      configurations = mkOption {
        type = listOf string;
        
        description = "- (Required) A list of IP addresses or IP ranges to match the request against specified in target, value pairs.  It&#39;s a complex value. See description below.   The order of the configuration entries is unimportant.";
      };
      # automatically generated, change the json file instead
      paused = mkOption {
        type = nullOr bool;
        default = null;
        description = "- (Optional) Boolean of whether this zone lockdown is currently paused. Default: false.";
      };
    }; }));
  };

  config =
    let
      result = flip mapAttrs
        config.cloudflare.resource.zone_lockdown
          (key: value:
          let
            filteredValues = filterAttrs (key: _: key != "extraConfig") value;
            extraConfig = value.extraConfig;
          in
            filteredValues // extraConfig);
    in
      mkIf ( config.cloudflare.enable && length (builtins.attrNames result) != 0 ) {
        resource.cloudflare_zone_lockdown = result;
      };
}

