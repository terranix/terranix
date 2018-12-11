
# automatically generated, you should change resource_user_gpg_key.json instead
# documentation : https://www.terraform.io/docs/providers/github/r/user_gpg_key.html
{ config, lib, ... }:
with lib;
with types;
{
  options.github.resource.user_gpg_key = mkOption {
    default = {};
    description = "";
    type = with types; attrsOf ( submodule ( { name, ... }: {
      options = {
      # internal object that should not be overwritten.
      # used to generate references
      "_ref" = mkOption {
        type = with types; string;
        default = "github_user_gpg_key.${name}";
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
      armored_public_key = mkOption {
        type = nullOr string;
        default = null;
        description = "- (Required) Your pulic GPG key, generated in ASCII-armored format.
See for help on creating a GPG key.";
      };
    }; }));
  };

  config =
    let
      result = flip mapAttrs
        config.github.resource.user_gpg_key
          (key: value:
          let
            filteredValues = filterAttrs (key: _: key != "extraConfig") value;
            extraConfig = value.extraConfig;
          in
            filteredValues // extraConfig);
    in
      mkIf ( config.github.enable && length (builtins.attrNames result) != 0 ) {
        resource.github_user_gpg_key = result;
      };
}

