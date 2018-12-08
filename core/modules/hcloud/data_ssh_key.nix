
# automatically generated, you should change data_ssh_key.json instead
# documentation : https://www.terraform.io/docs/providers/hcloud/d/ssh_key.html
{ config, lib, ... }:
with lib;
with types;
{
  options.hcloud.data.ssh_key = mkOption {
    default = {};
    description = "";
    type = with types; attrsOf ( submodule ({ name, ... }: {

      # internal object that should not be overwritten.
      # used to generate references
      "_ref" = mkOption {
        type = with types; string;
        default = "data.hcloud.ssh_key";
        description = "";
      };

      # automatically generated, change the json file instead
      id = mkOption {
        type = nullOr string;
        default = null;
        description = "- (Optional, string) ID of the SSH Key.";
      };
      # automatically generated, change the json file instead
      name = mkOption {
        type = nullOr string;
        default = null;
        description = "- (Optional, string) Name of the SSH Key.";
      };
      # automatically generated, change the json file instead
      fingerprint = mkOption {
        type = nullOr string;
        default = null;
        description = "- (Optional, string) Fingerprint of the SSH Key.";
      };
      # automatically generated, change the json file instead
      selector = mkOption {
        type = nullOr string;
        default = null;
        description = "- (Optional, string)";
      };
    }));
  };

  config = mkIf config.hcloud.enable {
    data.hcloud = config.hcloud.data.ssh_key;
  };

}

