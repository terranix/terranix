
# automatically generated, you should change resource_repository_deploy_key.json instead
# documentation : https://www.terraform.io/docs/providers/github/r/repository_deploy_key.html
{ config, lib, ... }:
with lib;
with types;
{
  options.github.resource.repository_deploy_key = mkOption {
    default = {};
    description = "";
    type = with types; attrsOf ( submodule ( { name, ... }: {
      options = {
      # internal object that should not be overwritten.
      # used to generate references
      "_ref" = mkOption {
        type = with types; string;
        default = "github_repository_deploy_key.${name}";
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
      key = mkOption {
        type = nullOr string;
        default = null;
        description = "- (Required) A ssh key.";
      };
      # automatically generated, change the json file instead
      read_only = mkOption {
        type = nullOr string;
        default = null;
        description = "- (Required) A boolean qualifying the key to be either read only or read/write.";
      };
      # automatically generated, change the json file instead
      repository = mkOption {
        type = nullOr string;
        default = null;
        description = "- (Required) Name of the GitHub repository.";
      };
      # automatically generated, change the json file instead
      title = mkOption {
        type = nullOr string;
        default = null;
        description = "- (Required) A title.";
      };
    }; }));
  };

  config =
    let
      result = flip mapAttrs
        config.github.resource.repository_deploy_key
          (key: value:
          let
            filteredValues = filterAttrs (key: _: key != "extraConfig") value;
            extraConfig = value.extraConfig;
          in
            filteredValues // extraConfig);
    in
      mkIf ( config.github.enable && length (builtins.attrNames result) != 0 ) {
        resource.github_repository_deploy_key = result;
      };
}

