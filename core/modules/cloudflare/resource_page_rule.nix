
# automatically generated, you should change resource_page_rule.json instead
# documentation : https://www.terraform.io/docs/providers/cloudflare/r/page_rule.html
{ config, lib, ... }:
with lib;
with types;
{
  options.cloudflare.resource.page_rule = mkOption {
    default = {};
    description = "";
    type = with types; attrsOf ( submodule {
      options = {
      # internal object that should not be overwritten.
      # used to generate references
      "_ref" = mkOption {
        type = with types; string;
        default = "cloudflare.page_rule";
        description = "";
      };

      # automatically generated, change the json file instead
      zone = mkOption {
        type = nullOr string;
        default = null;
        description = "- (Required) The DNS zone to which the page rule should be added.";
      };
      # automatically generated, change the json file instead
      target = mkOption {
        type = nullOr string;
        default = null;
        description = "- (Required) The URL pattern to target with the page rule.";
      };
      # automatically generated, change the json file instead
      actions = mkOption {
        type = nullOr string;
        default = null;
        description = "- (Required) The actions taken by the page rule, options given below.";
      };
      # automatically generated, change the json file instead
      priority = mkOption {
        type = nullOr string;
        default = null;
        description = "- (Optional) The priority of the page rule among others for this target.";
      };
      # automatically generated, change the json file instead
      status = mkOption {
        type = nullOr string;
        default = null;
        description = "- (Optional) Whether the page rule is active or disabled.";
      };
    }; });
  };

  config = mkIf config.cloudflare.enable {
    resource.cloudflare = config.cloudflare.resource.page_rule;
  };

}

