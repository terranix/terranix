
# automatically generated, you should change resource_team.json instead
# documentation : https://www.terraform.io/docs/providers/github/r/team.html
{ config, lib, ... }:
with lib;
with types;
{
  options.github.resource.team = mkOption {
    default = {};
    description = "";
    type = with types; attrsOf ( submodule ( { name, ... }: {
      options = {
      # internal object that should not be overwritten.
      # used to generate references
      "_ref" = mkOption {
        type = with types; string;
        default = "github_team.${name}";
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
      name = mkOption {
        type = nullOr string;
        default = null;
        description = "- (Required) The name of the team.";
      };
      # automatically generated, change the json file instead
      description = mkOption {
        type = nullOr string;
        default = null;
        description = "- (Optional) A description of the team.";
      };
      # automatically generated, change the json file instead
      privacy = mkOption {
        type = nullOr string;
        default = null;
        description = "- (Optional) The level of privacy for the team. Must be one of or .
           Defaults to .";
      };
      # automatically generated, change the json file instead
      parent_team_id = mkOption {
        type = nullOr string;
        default = null;
        description = "- (Optional) The ID of the parent team, if this is a nested team.";
      };
      # automatically generated, change the json file instead
      ldap_dn = mkOption {
        type = nullOr string;
        default = null;
        description = "- (Optional) The LDAP Distinguished Name of the group where membership will be synchronized. Only available in GitHub Enterprise.";
      };
    }; }));
  };

  config =
    let
      result = flip mapAttrs
        config.github.resource.team
          (key: value:
          let
            filteredValues = filterAttrs (key: _: key != "extraConfig") value;
            extraConfig = value.extraConfig;
          in
            filteredValues // extraConfig);
    in
      mkIf ( config.github.enable && length (builtins.attrNames result) != 0 ) {
        resource.github_team = result;
      };
}

