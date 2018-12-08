
# automatically generated, you should change resource_rdns.json instead
# documentation : https://www.terraform.io/docs/providers/hcloud/r/rdns.html
{ config, lib, ... }:
with lib;
with types;
{
  options.hcloud.resource.rdns = mkOption {
    default = {};
    description = "";
    type = with types; attrsOf ( submodule {
      options = {
      # internal object that should not be overwritten.
      # used to generate references
      "_ref" = mkOption {
        type = with types; string;
        default = "hcloud.rdns";
        description = "";
      };

      # automatically generated, change the json file instead
      dns_ptr = mkOption {
        type = nullOr string;
        default = null;
        description = "- (Required, string) The DNS address the should resolve to.";
      };
      # automatically generated, change the json file instead
      ip_address = mkOption {
        type = nullOr string;
        default = null;
        description = "- (Required, string) The IP address that should point to .";
      };
      # automatically generated, change the json file instead
      server_id = mkOption {
        type = nullOr string;
        default = null;
        description = "- (Required, int) The server the belongs to.";
      };
      # automatically generated, change the json file instead
      floating_ip_id = mkOption {
        type = nullOr string;
        default = null;
        description = "- (Required, int) The Floating IP the belongs to.";
      };
    }; });
  };

  config = mkIf config.hcloud.enable {
    resource.hcloud = config.hcloud.resource.rdns;
  };

}

