
# automatically generated, you should change resource_floating_ip.json instead
# documentation : https://www.terraform.io/docs/providers/hcloud/r/floating_ip.html
{ config, lib, ... }:
with lib;
with types;
{
  options.hcloud.resource.floating_ip = mkOption {
    default = {};
    description = "";
    type = with types; attrsOf ( submodule {
      options = {
      # internal object that should not be overwritten.
      # used to generate references
      "_ref" = mkOption {
        type = with types; string;
        default = "hcloud.floating_ip";
        description = "";
      };

      # automatically generated, change the json file instead
      type = mkOption {
        type = nullOr string;
        default = null;
        description = "- (Required, string) Type of the Floating IP.";
      };
      # automatically generated, change the json file instead
      server_id = mkOption {
        type = nullOr string;
        default = null;
        description = "- (Optional, int) Server to assign the Floating IP to.";
      };
      # automatically generated, change the json file instead
      home_location = mkOption {
        type = nullOr string;
        default = null;
        description = "- (Optional, string) Home location (routing is optimized for that location). Optional if server_id argument is passed.";
      };
      # automatically generated, change the json file instead
      description = mkOption {
        type = nullOr string;
        default = null;
        description = "- (Optional, string) Description of the Floating IP.";
      };
    }; });
  };

  config = mkIf config.hcloud.enable {
    resource.hcloud_floating_ip = config.hcloud.resource.floating_ip;
  };

}

