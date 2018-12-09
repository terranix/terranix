
# automatically generated, you should change data_ssh_key.json instead
# documentation : https://www.terraform.io/docs/providers/hcloud/d/ssh_key.html
{ config, lib, ... }:
with lib;
with types;
{
  options.hcloud.data.ssh_key = mkOption {
    default = {};
    description = "";
    type = with types; attrsOf ( submodule ( { name, ... }: {
      options = {
      # internal object that should not be overwritten.
      # used to generate references
      "_ref" = mkOption {
        type = with types; string;
        default = "data.hcloud_ssh_key.${name}";
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
    }; }));
  };

  config =
    let
      result = flip mapAttrs
        config.hcloud.data.ssh_key
          (key: value:
          let
            filteredValues = filterAttrs (key: _: key != "extraConfig") value;
            extraConfig = value.extraConfig;
          in
            filteredValues // extraConfig);
    in
      mkIf ( config.hcloud.enable && length (builtins.attrNames result) != 0 ) {
        data.hcloud_ssh_key = result;
      };
}

