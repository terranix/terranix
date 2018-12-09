
# automatically generated, you should change resource_volume_attachment.json instead
# documentation : https://www.terraform.io/docs/providers/hcloud/r/volume_attachment.html
{ config, lib, ... }:
with lib;
with types;
{
  options.hcloud.resource.volume_attachment = mkOption {
    default = {};
    description = "";
    type = with types; attrsOf ( submodule ( { name, ... }: {
      options = {
      # internal object that should not be overwritten.
      # used to generate references
      "_ref" = mkOption {
        type = with types; string;
        default = "hcloud_volume_attachment.${name}";
        description = "";
      };

      # automatically generated
      extraConfig = mkOption {
        type = nullOr attrs;
        default = {};
        example = { provider = "aws.route53"; };
        description = "use this option to add options not coverd by this module";
      };

      # automatically generated, change the json file instead
      volume_id = mkOption {
        type = int;
        
        description = "- (Required, int) ID of the Volume.";
      };
      # automatically generated, change the json file instead
      server_id = mkOption {
        type = int;
        
        description = "- (Required, int) Server to attach the Volume to.";
      };
    }; }));
  };

  config =
    let
      result = flip mapAttrs
        config.hcloud.resource.volume_attachment
          (key: value:
          let
            filteredValues = filterAttrs (key: _: key != "extraConfig") value;
            extraConfig = value.extraConfig;
          in
            filteredValues // extraConfig);
    in
      mkIf ( config.hcloud.enable && length (builtins.attrNames result) != 0 ) {
        resource.hcloud_volume_attachment = result;
      };
}

