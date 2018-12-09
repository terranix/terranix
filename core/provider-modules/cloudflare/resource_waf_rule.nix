
# automatically generated, you should change resource_waf_rule.json instead
# documentation : https://www.terraform.io/docs/providers/cloudflare/r/waf_rule.html
{ config, lib, ... }:
with lib;
with types;
{
  options.cloudflare.resource.waf_rule = mkOption {
    default = {};
    description = "";
    type = with types; attrsOf ( submodule ( { name, ... }: {
      options = {
      # internal object that should not be overwritten.
      # used to generate references
      "_ref" = mkOption {
        type = with types; string;
        default = "cloudflare_waf_rule.${name}";
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
        
        description = "- (Required) The DNS zone to apply to.";
      };
      # automatically generated, change the json file instead
      rule_id = mkOption {
        type = string;
        
        description = "- (Required) The WAF Rule ID.";
      };
      # automatically generated, change the json file instead
      mode = mkOption {
        type = enum [ "block" "challenge" "default" "disable" "simulate" ];
        
        description = "- (Required) The mode of the rule, can be one of [&#34;block&#34;, &#34;challenge&#34;, &#34;default&#34;, &#34;disable, &#34;simulate&#34;].";
      };
    }; }));
  };

  config =
    let
      result = flip mapAttrs
        config.cloudflare.resource.waf_rule
          (key: value:
          let
            filteredValues = filterAttrs (key: _: key != "extraConfig") value;
            extraConfig = value.extraConfig;
          in
            filteredValues // extraConfig);
    in
      mkIf ( config.cloudflare.enable && length (builtins.attrNames result) != 0 ) {
        resource.cloudflare_waf_rule = result;
      };
}

