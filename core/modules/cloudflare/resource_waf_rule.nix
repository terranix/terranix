
# automatically generated, you should change resource_waf_rule.json instead
# documentation : https://www.terraform.io/docs/providers/cloudflare/r/waf_rule.html
{ config, lib, ... }:
with lib;
with types;
{
  options.cloudflare.resource.waf_rule = mkOption {
    default = {};
    description = "";
    type = with types; attrsOf ( submodule {
      options = {
      # internal object that should not be overwritten.
      # used to generate references
      "_ref" = mkOption {
        type = with types; string;
        default = "cloudflare.waf_rule";
        description = "";
      };

      # automatically generated, change the json file instead
      zone = mkOption {
        type = nullOr string;
        default = null;
        description = "- (Required) The DNS zone to apply to.";
      };
      # automatically generated, change the json file instead
      rule_id = mkOption {
        type = nullOr string;
        default = null;
        description = "- (Required) The WAF Rule ID.";
      };
      # automatically generated, change the json file instead
      mode = mkOption {
        type = nullOr string;
        default = null;
        description = "- (Required) The mode of the rule, can be one of [&#34;block&#34;, &#34;challenge&#34;, &#34;default&#34;, &#34;disable, &#34;simulate&#34;].";
      };
    }; });
  };

  config = mkIf config.cloudflare.enable {
    resource.cloudflare_waf_rule = config.cloudflare.resource.waf_rule;
  };

}

