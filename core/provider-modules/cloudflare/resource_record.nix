
# automatically generated, you should change resource_record.json instead
# documentation : https://www.terraform.io/docs/providers/cloudflare/r/record.html
{ config, lib, ... }:
with lib;
with types;
{
  options.cloudflare.resource.record = mkOption {
    default = {};
    description = "";
    type = with types; attrsOf ( submodule ( { name, ... }: {
      options = {
      # internal object that should not be overwritten.
      # used to generate references
      "_ref" = mkOption {
        type = with types; string;
        default = "cloudflare_record.${name}";
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
      domain = mkOption {
        type = string;
        
        description = "- (Required) The DNS zone to add the record to";
      };
      # automatically generated, change the json file instead
      name = mkOption {
        type = string;
        
        description = "- (Required) The name of the record";
      };
      # automatically generated, change the json file instead
      type = mkOption {
        type = string;
        
        description = "- (Required) The type of the record";
      };
      # automatically generated, change the json file instead
      value = mkOption {
        type = string;
        
        description = "- (Optional) The (string) value of the record. Either this or must be specified";
      };
      # automatically generated, change the json file instead
      data = mkOption {
        type = nullOr attrs;
        default = null;
        description = "- (Optional) Map of attributes that constitute the record value. Primarily used for LOC and SRV record types. Either this or must be specified";
      };
      # automatically generated, change the json file instead
      ttl = mkOption {
        type = nullOr (either string int);
        default = null;
        description = "- (Optional) The TTL of the record ( )";
      };
      # automatically generated, change the json file instead
      priority = mkOption {
        type = nullOr (either string int);
        default = null;
        description = "- (Optional) The priority of the record";
      };
      # automatically generated, change the json file instead
      proxied = mkOption {
        type = nullOr bool;
        default = null;
        description = "- (Optional) Whether the record gets Cloudflare&#39;s origin protection; defaults to .";
      };
    }; }));
  };

  config =
    let
      result = flip mapAttrs
        config.cloudflare.resource.record
          (key: value:
          let
            filteredValues = filterAttrs (key: _: key != "extraConfig") value;
            extraConfig = value.extraConfig;
          in
            filteredValues // extraConfig);
    in
      mkIf ( config.cloudflare.enable && length (builtins.attrNames result) != 0 ) {
        resource.cloudflare_record = result;
      };
}

