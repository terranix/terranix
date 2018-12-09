
# automatically generated, you should change data_volume.json instead
# documentation : https://www.terraform.io/docs/providers/hcloud/d/volume.html
{ config, lib, ... }:
with lib;
with types;
{
  options.hcloud.data.volume = mkOption {
    default = {};
    description = "";
    type = with types; attrsOf ( submodule ( { name, ... }: {
      options = {
      # internal object that should not be overwritten.
      # used to generate references
      "_ref" = mkOption {
        type = with types; string;
        default = "data.hcloud_volume.${name}";
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
    }; }));
  };

  config =
    let
      result = flip mapAttrs
        config.hcloud.data.volume
          (key: value:
          let
            filteredValues = filterAttrs (key: _: key != "extraConfig") value;
            extraConfig = value.extraConfig;
          in
            filteredValues // extraConfig);
    in
      mkIf ( config.hcloud.enable && length (builtins.attrNames result) != 0 ) {
        data.hcloud_volume = result;
      };
}

