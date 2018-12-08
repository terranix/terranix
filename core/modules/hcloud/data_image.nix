
# automatically generated, you should change data_image.json instead
# documentation : https://www.terraform.io/docs/providers/hcloud/d/image.html
{ config, lib, ... }:
with lib;
with types;
{
  options.hcloud.data.image = mkOption {
    default = {};
    description = "";
    type = with types; attrsOf ( submodule {
      options = {
      # internal object that should not be overwritten.
      # used to generate references
      "_ref" = mkOption {
        type = with types; string;
        default = "data.hcloud.image";
        description = "";
      };

      # automatically generated, change the json file instead
      id = mkOption {
        type = nullOr string;
        default = null;
        description = "- (Optional, string) ID of the Image.";
      };
      # automatically generated, change the json file instead
      name = mkOption {
        type = nullOr string;
        default = null;
        description = "- (Optional, string) Name of the Image.";
      };
      # automatically generated, change the json file instead
      selector = mkOption {
        type = nullOr string;
        default = null;
        description = "- (Optional, string)";
      };
      # automatically generated, change the json file instead
      most_recent = mkOption {
        type = nullOr string;
        default = null;
        description = "- (Optional, bool) If more than one result is returned, use the most recent Image.";
      };
    }; });
  };

  config = mkIf config.hcloud.enable {
    data.hcloud = config.hcloud.data.image;
  };

}

