
# automatically generated, you should change resource_access_rule.json instead
# documentation : https://www.terraform.io/docs/providers/cloudflare/r/access_rule.html
{ config, lib, ... }:
with lib;
with types;
{
  options.cloudflare.resource.access_rule = mkOption {
    default = {};
    description = "";
    type = with types; attrsOf ( submodule ({ name, ... }: {

      # internal object that should not be overwritten.
      # used to generate references
      "_ref" = mkOption {
        type = with types; string;
        default = "cloudflare.access_rule";
        description = "";
      };

      # automatically generated, change the json file instead
      zone = mkOption {
        type = nullOr string;
        default = null;
        description = "- (Optional) The DNS zone to which the access rule should be added. Will be resolved to upon creation.";
      };
      # automatically generated, change the json file instead
      zone_id = mkOption {
        type = nullOr string;
        default = null;
        description = "- (Optional) The DNS zone to which the access rule should be added.";
      };
      # automatically generated, change the json file instead
      mode = mkOption {
        type = nullOr string;
        default = null;
        description = "- (Required) The action to apply to a matched request. Allowed values: &#34;block&#34;, &#34;challenge&#34;, &#34;whitelist&#34;, &#34;js_challenge&#34;";
      };
      # automatically generated, change the json file instead
      notes = mkOption {
        type = nullOr string;
        default = null;
        description = "- (Optional) A personal note about the rule. Typically used as a reminder or explanation for the rule.";
      };
      # automatically generated, change the json file instead
      configuration = mkOption {
        type = nullOr string;
        default = null;
        description = "- (Required) Rule configuration to apply to a matched request. It&#39;s a complex value. See description below.";
      };
    }));
  };

  config = mkIf config.cloudflare.enable {
    resource.cloudflare = config.cloudflare.resource.access_rule;
  };

}

