
# automatically generated, you should change resource_membership.json instead
# documentation : https://www.terraform.io/docs/providers/github/r/membership.html
{ config, lib, ... }:
with lib;
with types;
{
  options.github.resource.membership = mkOption {
    default = {};
    description = "";
    type = with types; attrsOf ( submodule ( { name, ... }: {
      options = {
      # internal object that should not be overwritten.
      # used to generate references
      "_ref" = mkOption {
        type = with types; string;
        default = "github_membership.${name}";
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
      username = mkOption {
        type = nullOr string;
        default = null;
        description = "- (Required) The user to add to the organization.";
      };
      # automatically generated, change the json file instead
      role = mkOption {
        type = nullOr string;
        default = null;
        description = "- (Optional) The role of the user within the organization.
        Must be one of or . Defaults to .";
      };
    }; }));
  };

  config =
    let
      result = flip mapAttrs
        config.github.resource.membership
          (key: value:
          let
            filteredValues = filterAttrs (key: _: key != "extraConfig") value;
            extraConfig = value.extraConfig;
          in
            filteredValues // extraConfig);
    in
      mkIf ( config.github.enable && length (builtins.attrNames result) != 0 ) {
        resource.github_membership = result;
      };
}

