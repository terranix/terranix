
# automatically generated, you should change resource_record.json instead
# documentation : https://www.terraform.io/docs/providers/cloudflare/r/record.html
{ config, lib, ... }:
with lib;
with types;
{
  options.cloudflare.resource.record = mkOption {
    default = {};
    description = "";
    type = with types; attrsOf ( submodule {
      options = {
      # internal object that should not be overwritten.
      # used to generate references
      "_ref" = mkOption {
        type = with types; string;
        default = "cloudflare.record";
        description = "";
      };

      # automatically generated, change the json file instead
      domain = mkOption {
        type = nullOr string;
        default = null;
        description = "- (Required) The DNS zone to add the record to";
      };
      # automatically generated, change the json file instead
      name = mkOption {
        type = nullOr string;
        default = null;
        description = "- (Required) The name of the record";
      };
      # automatically generated, change the json file instead
      type = mkOption {
        type = nullOr string;
        default = null;
        description = "- (Required) The type of the record";
      };
      # automatically generated, change the json file instead
      value = mkOption {
        type = nullOr string;
        default = null;
        description = "- (Optional) The (string) value of the record. Either this or must be specified";
      };
      # automatically generated, change the json file instead
      data = mkOption {
        type = nullOr string;
        default = null;
        description = "- (Optional) Map of attributes that constitute the record value. Primarily used for LOC and SRV record types. Either this or must be specified";
      };
      # automatically generated, change the json file instead
      ttl = mkOption {
        type = nullOr string;
        default = null;
        description = "- (Optional) The TTL of the record ( )";
      };
      # automatically generated, change the json file instead
      priority = mkOption {
        type = nullOr string;
        default = null;
        description = "- (Optional) The priority of the record";
      };
      # automatically generated, change the json file instead
      proxied = mkOption {
        type = nullOr string;
        default = null;
        description = "- (Optional) Whether the record gets Cloudflare&#39;s origin protection; defaults to .";
      };
    }; });
  };

  config = mkIf config.cloudflare.enable {
    resource.cloudflare_record = config.cloudflare.resource.record;
  };

}

