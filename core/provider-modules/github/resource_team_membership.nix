
# automatically generated, you should change resource_team_membership.json instead
# documentation : https://www.terraform.io/docs/providers/github/r/team_membership.html
{ config, lib, ... }:
with lib;
with types;
{
  options.github.resource.team_membership = mkOption {
    default = {};
    description = "";
    type = with types; attrsOf ( submodule ( { name, ... }: {
      options = {
      # internal object that should not be overwritten.
      # used to generate references
      "_ref" = mkOption {
        type = with types; string;
        default = "github_team_membership.${name}";
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
      team_id = mkOption {
        type = nullOr string;
        default = null;
        description = "- (Required) The GitHub team id";
      };
      # automatically generated, change the json file instead
      username = mkOption {
        type = nullOr string;
        default = null;
        description = "- (Required) The user to add to the team.";
      };
      # automatically generated, change the json file instead
      role = mkOption {
        type = nullOr string;
        default = null;
        description = "- (Optional) The role of the user within the team.
        Must be one of or . Defaults to .";
      };
    }; }));
  };

  config =
    let
      result = flip mapAttrs
        config.github.resource.team_membership
          (key: value:
          let
            filteredValues = filterAttrs (key: _: key != "extraConfig") value;
            extraConfig = value.extraConfig;
          in
            filteredValues // extraConfig);
    in
      mkIf ( config.github.enable && length (builtins.attrNames result) != 0 ) {
        resource.github_team_membership = result;
      };
}

