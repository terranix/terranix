
# automatically generated, you should change resource_ssh_key.json instead
# documentation : https://www.terraform.io/docs/providers/hcloud/r/ssh_key.html
{ config, lib, ... }:
with lib;
with types;
{
  options.hcloud.resource.ssh_key = mkOption {
    default = {};
    description = "";
    type = with types; attrsOf ( submodule ( { name, ... }: {
      options = {
      # internal object that should not be overwritten.
      # used to generate references
      "_ref" = mkOption {
        type = with types; string;
        default = "hcloud_ssh_key.${name}";
        description = "";
      };

      # automatically generated, change the json file instead
      name = mkOption {
        type = nullOr string;
        default = null;
        description = "- (Required, string) Name of the SSH key.";
      };
      # automatically generated, change the json file instead
      public_key = mkOption {
        type = nullOr string;
        default = null;
        description = "- (Required, string) The public key. If this is a file, it can be read using the file interpolation function";
      };
    }; }));
  };

  config = mkIf config.hcloud.enable {
    resource.hcloud_ssh_key = config.hcloud.resource.ssh_key;
  };

}

