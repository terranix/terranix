
# automatically generated, you should change data_remote_state.json instead
# documentation : https://www.terraform.io/docs/providers/terraform/d/remote_state.html
{ config, lib, ... }:
with lib;
with types;
{
  options.terraform.data.remote_state = mkOption {
    default = {};
    description = "";
    type = with types; attrsOf ( submodule ( { name, ... }: {
      options = {
      # internal object that should not be overwritten.
      # used to generate references
      "_ref" = mkOption {
        type = with types; string;
        default = "data.terraform_remote_state.${name}";
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
      backend = mkOption {
        type = nullOr string;
        default = null;
        description = "- (Required) The remote backend to use.";
      };
      # automatically generated, change the json file instead
      workspace = mkOption {
        type = nullOr string;
        default = null;
        description = "- (Optional) The Terraform workspace to use, if the backend
supports workspaces.";
      };
      # automatically generated, change the json file instead
      config = mkOption {
        type = nullOr string;
        default = null;
        description = "- (Optional; block) The configuration of the remote backend. The block can use any arguments that would be valid in the equivalent block. See for details.";
      };
      # automatically generated, change the json file instead
      defaults = mkOption {
        type = nullOr string;
        default = null;
        description = "- (Optional; block) Default values for outputs, in case the state
file is empty or lacks a required output.";
      };
    }; }));
  };

  config =
    let
      result = flip mapAttrs
        config.terraform.data.remote_state
          (key: value:
          let
            filteredValues = filterAttrs (key: _: key != "extraConfig") value;
            extraConfig = value.extraConfig;
          in
            filteredValues // extraConfig);
    in
      mkIf ( config.terraform.enable && length (builtins.attrNames result) != 0 ) {
        data.terraform_remote_state = result;
      };
}

