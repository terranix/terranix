
# automatically generated, you should change resource_user_ssh_key.json instead
# documentation : https://www.terraform.io/docs/providers/github/r/user_ssh_key.html
{ config, lib, ... }:
with lib;
with types;
{
  options.github.resource.user_ssh_key = mkOption {
    default = {};
    description = "";
    type = with types; attrsOf ( submodule ( { name, ... }: {
      options = {
      # internal object that should not be overwritten.
      # used to generate references
      "_ref" = mkOption {
        type = with types; string;
        default = "github_user_ssh_key.${name}";
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
      title = mkOption {
        type = nullOr string;
        default = null;
        description = "- (Required) A descriptive name for the new key. e.g.";
      };
      # automatically generated, change the json file instead
      key = mkOption {
        type = nullOr string;
        default = null;
        description = "- (Required) The public SSH key to add to your GitHub account.";
      };
    }; }));
  };

  config =
    let
      result = flip mapAttrs
        config.github.resource.user_ssh_key
          (key: value:
          let
            filteredValues = filterAttrs (key: _: key != "extraConfig") value;
            extraConfig = value.extraConfig;
          in
            filteredValues // extraConfig);
    in
      mkIf ( config.github.enable && length (builtins.attrNames result) != 0 ) {
        resource.github_user_ssh_key = result;
      };
}

