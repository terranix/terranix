
# automatically generated, you should change resource_volume_attachment.json instead
# documentation : https://www.terraform.io/docs/providers/hcloud/r/volume_attachment.html
{ config, lib, ... }:
with lib;
with types;
{
  options.hcloud.resource.volume_attachment = mkOption {
    default = {};
    description = "";
    type = with types; attrsOf ( submodule ({ name, ... }: {

      # internal object that should not be overwritten.
      # used to generate references
      "_ref" = mkOption {
        type = with types; string;
        default = "hcloud.volume_attachment";
        description = "";
      };

      # automatically generated, change the json file instead
      volume_id = mkOption {
        type = nullOr string;
        default = null;
        description = "- (Required, int) ID of the Volume.";
      };
      # automatically generated, change the json file instead
      server_id = mkOption {
        type = nullOr string;
        default = null;
        description = "- (Required, int) Server to attach the Volume to.";
      };
    }));
  };

  config = mkIf config.hcloud.enable {
    resource.hcloud = config.hcloud.resource.volume_attachment;
  };

}

