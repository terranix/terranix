
# automatically generated, you should change data_repositories.json instead
# documentation : https://www.terraform.io/docs/providers/github/d/repositories.html
{ config, lib, ... }:
with lib;
with types;
{
  options.github.data.repositories = mkOption {
    default = {};
    description = "";
    type = with types; attrsOf ( submodule ( { name, ... }: {
      options = {
      # internal object that should not be overwritten.
      # used to generate references
      "_ref" = mkOption {
        type = with types; string;
        default = "data.github_repositories.${name}";
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
      query = mkOption {
        type = nullOr string;
        default = null;
        description = "- (Required) Search query. See .";
      };
    }; }));
  };

  config =
    let
      result = flip mapAttrs
        config.github.data.repositories
          (key: value:
          let
            filteredValues = filterAttrs (key: _: key != "extraConfig") value;
            extraConfig = value.extraConfig;
          in
            filteredValues // extraConfig);
    in
      mkIf ( config.github.enable && length (builtins.attrNames result) != 0 ) {
        data.github_repositories = result;
      };
}

