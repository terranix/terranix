
# automatically generated, you should change resource_volume.json instead
# documentation : https://www.terraform.io/docs/providers/hcloud/r/volume.html
{ config, lib, ... }:
with lib;
with types;
{
  options.hcloud.resource.volume = mkOption {
    default = {};
    description = "";
    type = with types; attrsOf ( submodule ( { name, ... }: {
      options = {
      # internal object that should not be overwritten.
      # used to generate references
      "_ref" = mkOption {
        type = with types; string;
        default = "hcloud_volume.${name}";
        description = "";
      };

      # automatically generated
      extraConfig = mkOption {
        type = nullOr attrs;
        default = null;
        example = { provider = "aws.route53"; };
        description = "use this option to add options not coverd by this module";
      };

      # automatically generated, change the json file instead
      name = mkOption {
        type = string;
        
        description = "- (Required, string) Name of the volume to create (must be unique per project).";
      };
      # automatically generated, change the json file instead
      size = mkOption {
        type = int;
        
        description = "- (Required, int) Size of the volume (in GB).";
      };
      # automatically generated, change the json file instead
      server = mkOption {
        type = nullOr int;
        default = null;
        description = "- (Optional, int) Server to attach the Volume to, optional if location argument is passed.";
      };
      # automatically generated, change the json file instead
      location = mkOption {
        type = nullOr string;
        default = null;
        description = "- (Optional, string) Location of the volume to create, optional if server_id argument is passed.";
      };
    }; }));
  };

  config = mkIf config.hcloud.enable {
    resource.hcloud_volume = flip mapAttrs
      config.hcloud.resource.volume
        (key: value:
        let
          filteredValues = filterAttrs (key: _: key != "extraConfig") value;
          extraConfig = value.extraConfig;
        in
          filteredValues // extraConfig);



  };

}

