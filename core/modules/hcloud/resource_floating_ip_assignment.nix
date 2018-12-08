
# automatically generated, you should change resource_floating_ip_assignment.json instead
# documentation : https://www.terraform.io/docs/providers/hcloud/r/floating_ip_assignment.html
{ config, lib, ... }:
with lib;
with types;
{
  options.hcloud.resource.floating_ip_assignment = mkOption {
    default = {};
    description = "";
    type = with types; attrsOf ( submodule {
      options = {
      # internal object that should not be overwritten.
      # used to generate references
      "_ref" = mkOption {
        type = with types; string;
        default = "hcloud.floating_ip_assignment";
        description = "";
      };

      # automatically generated, change the json file instead
      floating_ip_id = mkOption {
        type = nullOr string;
        default = null;
        description = "- (Required, int) ID of the Floating IP.";
      };
      # automatically generated, change the json file instead
      server_id = mkOption {
        type = nullOr string;
        default = null;
        description = "- (Required, int) Server to assign the Floating IP to.";
      };
    }; });
  };

  config = mkIf config.hcloud.enable {
    resource.hcloud_floating_ip_assignment = config.hcloud.resource.floating_ip_assignment;
  };

}

