
# automatically generated, you should change resource_firewall_rule.json instead
# documentation : https://www.terraform.io/docs/providers/cloudflare/r/firewall_rule.html
{ config, lib, ... }:
with lib;
with types;
{
  options.cloudflare.resource.firewall_rule = mkOption {
    default = {};
    description = "";
    type = with types; attrsOf ( submodule ( { name, ... }: {
      options = {
      # internal object that should not be overwritten.
      # used to generate references
      "_ref" = mkOption {
        type = with types; string;
        default = "cloudflare_firewall_rule.${name}";
        description = "";
      };

      # automatically generated
      extraConfig = mkOption {
        type = nullOr attrs;
        default = {};
        example = { provider = "aws.route53"; };
        description = "use this option to add options not coverd by this module";
      };

      # automatically generated, change the json file instead
      zone = mkOption {
        type = nullOr string;
        default = null;
        description = "- (Optional) The DNS zone to which the Firewall Rule should be added. Will be resolved to upon creation.";
      };
      # automatically generated, change the json file instead
      zone_id = mkOption {
        type = nullOr string;
        default = null;
        description = "- (Optional) The DNS zone to which the Filter should be added.";
      };
      # automatically generated, change the json file instead
      action = mkOption {
        type = enum [ "block" "challenge" "allow" "js_challenge" ];
        
        description = "- (Required) The action to apply to a matched request. Allowed values: &#34;block&#34;, &#34;challenge&#34;, &#34;allow&#34;, &#34;js_challenge&#34;.";
      };
      # automatically generated, change the json file instead
      priority = mkOption {
        type = nullOr (either string int);
        default = null;
        description = "- (Optional) The priority of the rule to allow control of processing order. A lower number indicates high priority. If not provided, any rules with a priority will be sequenced before those without.";
      };
      # automatically generated, change the json file instead
      paused = mkOption {
        type = nullOr bool;
        default = null;
        description = "- (Optional) Whether this filter based firewall rule is currently paused. Boolean value.";
      };
      # automatically generated, change the json file instead
      expression = mkOption {
        type = string;
        
        description = "- (Required) The filter expression to be used.";
      };
      # automatically generated, change the json file instead
      description = mkOption {
        type = nullOr string;
        default = null;
        description = "- (Optional) A description of the rule to help identify it.";
      };
    }; }));
  };

  config =
    let
      result = flip mapAttrs
        config.cloudflare.resource.firewall_rule
          (key: value:
          let
            filteredValues = filterAttrs (key: _: key != "extraConfig") value;
            extraConfig = value.extraConfig;
          in
            filteredValues // extraConfig);
    in
      mkIf ( config.cloudflare.enable && length (builtins.attrNames result) != 0 ) {
        resource.cloudflare_firewall_rule = result;
      };
}

