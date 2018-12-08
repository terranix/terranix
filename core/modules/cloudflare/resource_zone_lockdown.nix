
# automatically generated, you should change resource_zone_lockdown.json instead
# documentation : https://www.terraform.io/docs/providers/cloudflare/r/zone_lockdown.html
{ config, lib, ... }:
with lib;
with types;
{
  options.cloudflare.resource.zone_lockdown = mkOption {
    default = {};
    description = "";
    type = with types; attrsOf ( submodule {
      options = {
      # internal object that should not be overwritten.
      # used to generate references
      "_ref" = mkOption {
        type = with types; string;
        default = "cloudflare.zone_lockdown";
        description = "";
      };

      # automatically generated, change the json file instead
      zone = mkOption {
        type = nullOr string;
        default = null;
        description = "- The DNS zone to which the lockdown will be added. Will be resolved to upon creation.";
      };
      # automatically generated, change the json file instead
      zone_id = mkOption {
        type = nullOr string;
        default = null;
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
        type = nullOr string;
        default = null;
        description = "- (Required) A list of simple wildcard patterns to match requests against. The order of the urls is unimportant.";
      };
      # automatically generated, change the json file instead
      configurations = mkOption {
        type = nullOr string;
        default = null;
        description = "- (Required) A list of IP addresses or IP ranges to match the request against specified in target, value pairs.  It&#39;s a complex value. See description below.   The order of the configuration entries is unimportant.";
      };
      # automatically generated, change the json file instead
      paused = mkOption {
        type = nullOr string;
        default = null;
        description = "- (Optional) Boolean of whether this zone lockdown is currently paused. Default: false.";
      };
    }; });
  };

  config = mkIf config.cloudflare.enable {
    resource.cloudflare = config.cloudflare.resource.zone_lockdown;
  };

}

