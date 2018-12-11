
# automatically generated, you should change resource_team_repository.json instead
# documentation : https://www.terraform.io/docs/providers/github/r/team_repository.html
{ config, lib, ... }:
with lib;
with types;
{
  options.github.resource.team_repository = mkOption {
    default = {};
    description = "";
    type = with types; attrsOf ( submodule ( { name, ... }: {
      options = {
      # internal object that should not be overwritten.
      # used to generate references
      "_ref" = mkOption {
        type = with types; string;
        default = "github_team_repository.${name}";
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
      repository = mkOption {
        type = nullOr string;
        default = null;
        description = "- (Required) The repository to add to the team.";
      };
      # automatically generated, change the json file instead
      permission = mkOption {
        type = nullOr string;
        default = null;
        description = "- (Optional) The permissions of team members regarding the repository.
Must be one of , , or . Defaults to .";
      };
    }; }));
  };

  config =
    let
      result = flip mapAttrs
        config.github.resource.team_repository
          (key: value:
          let
            filteredValues = filterAttrs (key: _: key != "extraConfig") value;
            extraConfig = value.extraConfig;
          in
            filteredValues // extraConfig);
    in
      mkIf ( config.github.enable && length (builtins.attrNames result) != 0 ) {
        resource.github_team_repository = result;
      };
}

