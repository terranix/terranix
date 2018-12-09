
# automatically generated, you should change resource_floating_ip.json instead
# documentation : https://www.terraform.io/docs/providers/hcloud/r/floating_ip.html
{ config, lib, ... }:
with lib;
with types;
{
  options.hcloud.resource.floating_ip = mkOption {
    default = {};
    description = "";
    type = with types; attrsOf ( submodule ( { name, ... }: {
      options = {
      # internal object that should not be overwritten.
      # used to generate references
      "_ref" = mkOption {
        type = with types; string;
        default = "hcloud_floating_ip.${name}";
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
    }; }));
  };

  config =
    let
      result = flip mapAttrs
        config.hcloud.resource.floating_ip
          (key: value:
          let
            filteredValues = filterAttrs (key: _: key != "extraConfig") value;
            extraConfig = value.extraConfig;
          in
            filteredValues // extraConfig);
    in
      mkIf ( config.hcloud.enable && length (builtins.attrNames result) != 0 ) {
        resource.hcloud_floating_ip = result;
      };
}

