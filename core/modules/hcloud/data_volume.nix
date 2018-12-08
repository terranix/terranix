
# automatically generated, you should change data_volume.json instead
# documentation : https://www.terraform.io/docs/providers/hcloud/d/volume.html
{ config, lib, ... }:
with lib;
with types;
{
  options.hcloud.data.volume = mkOption {
    default = {};
    description = "";
    type = with types; attrsOf ( submodule ({ name, ... }: {

      # internal object that should not be overwritten.
      # used to generate references
      "_ref" = mkOption {
        type = with types; string;
        default = "data.hcloud.volume";
        description = "";
      };

      # automatically generated, change the json file instead
      id = mkOption {
        type = nullOr string;
        default = null;
        description = "- ID of the volume.";
      };
      # automatically generated, change the json file instead
      name = mkOption {
        type = nullOr string;
        default = null;
        description = "- Name of the volume.";
      };
      # automatically generated, change the json file instead
      selector = mkOption {
        type = nullOr string;
        default = null;
        description = "- Label Selector. For more information about possible values, visit the .";
      };
    }));
  };

  config = mkIf config.hcloud.enable {
    data.hcloud = config.hcloud.data.volume;
  };

}

