
# automatically generated, you should change resource_repository_collaborator.json instead
# documentation : https://www.terraform.io/docs/providers/github/r/repository_collaborator.html
{ config, lib, ... }:
with lib;
with types;
{
  options.github.resource.repository_collaborator = mkOption {
    default = {};
    description = "";
    type = with types; attrsOf ( submodule ( { name, ... }: {
      options = {
      # internal object that should not be overwritten.
      # used to generate references
      "_ref" = mkOption {
        type = with types; string;
        default = "github_repository_collaborator.${name}";
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
      repository = mkOption {
        type = nullOr string;
        default = null;
        description = "- (Required) The GitHub repository";
      };
      # automatically generated, change the json file instead
      username = mkOption {
        type = nullOr string;
        default = null;
        description = "- (Required) The user to add to the repository as a collaborator.";
      };
      # automatically generated, change the json file instead
      permission = mkOption {
        type = nullOr string;
        default = null;
        description = "- (Optional) The permission of the outside collaborator for the repository.
        Must be one of , , or . Defaults to .";
      };
    }; }));
  };

  config =
    let
      result = flip mapAttrs
        config.github.resource.repository_collaborator
          (key: value:
          let
            filteredValues = filterAttrs (key: _: key != "extraConfig") value;
            extraConfig = value.extraConfig;
          in
            filteredValues // extraConfig);
    in
      mkIf ( config.github.enable && length (builtins.attrNames result) != 0 ) {
        resource.github_repository_collaborator = result;
      };
}

