
# automatically generated, you should change resource_access_policy.json instead
# documentation : https://www.terraform.io/docs/providers/cloudflare/r/access_policy.html
{ config, lib, ... }:
with lib;
with types;
{
  options.cloudflare.resource.access_policy = mkOption {
    default = {};
    description = "";
    type = with types; attrsOf ( submodule ( { name, ... }: {
      options = {
      # internal object that should not be overwritten.
      # used to generate references
      "_ref" = mkOption {
        type = with types; string;
        default = "cloudflare_access_policy.${name}";
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
      application_id = mkOption {
        type = string;
        
        description = "- (Required) The ID of the application the policy is
associated with.";
      };
      # automatically generated, change the json file instead
      zone_id = mkOption {
        type = string;
        
        description = "- (Required) The DNS zone to which the access rule should be
added.";
      };
      # automatically generated, change the json file instead
      decision = mkOption {
        type = string;
        
        description = "- (Required) The complete URL of the asset you wish to put
Cloudflare Access in front of. Can include subdomains or paths. Or both.";
      };
      # automatically generated, change the json file instead
      name = mkOption {
        type = string;
        
        description = "- (Required) Friendly name of the Access Application.";
      };
      # automatically generated, change the json file instead
      precedence = mkOption {
        type = nullOr string;
        default = null;
        description = "- (Optional) Friendly name of the Access Application.";
      };
      # automatically generated, change the json file instead
      require = mkOption {
        type = nullOr (listOf string);
        default = null;
        description = "- (Optional) A series of access conditions, see below for
full list.";
      };
      # automatically generated, change the json file instead
      exclude = mkOption {
        type = nullOr (listOf string);
        default = null;
        description = "- (Optional) A series of access conditions, see below for
full list.";
      };
      # automatically generated, change the json file instead
      include = mkOption {
        type = listOf string;
        
        description = "- (Required) A series of access conditions, see below for
full list.";
      };
    }; }));
  };

  config =
    let
      result = flip mapAttrs
        config.cloudflare.resource.access_policy
          (key: value:
          let
            filteredValues = filterAttrs (key: _: key != "extraConfig") value;
            extraConfig = value.extraConfig;
          in
            filteredValues // extraConfig);
    in
      mkIf ( config.cloudflare.enable && length (builtins.attrNames result) != 0 ) {
        resource.cloudflare_access_policy = result;
      };
}

