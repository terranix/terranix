
# automatically generated, you should change resource_account_member.json instead
# documentation : https://www.terraform.io/docs/providers/cloudflare/r/account_member.html
{ config, lib, ... }:
with lib;
with types;
{
  options.cloudflare.resource.account_member = mkOption {
    default = {};
    description = "";
    type = with types; attrsOf ( submodule ( { name, ... }: {
      options = {
      # internal object that should not be overwritten.
      # used to generate references
      "_ref" = mkOption {
        type = with types; string;
        default = "cloudflare_account_member.${name}";
        description = "";
      };

      # automatically generated
      extraConfig = mkOption {
        type = nullOr attrs;
        default = null;
        example = { provider = "aws.route53"; };
        description = "use this option to add options not coverd by this module";
      };

      # automatically generated, change the json file instead
      email_address = mkOption {
        type = string;
        
        description = "- (Required) The email address of the user who you wish to manage. Note: Following creation, this field becomes read only via the API and cannot be updated.";
      };
      # automatically generated, change the json file instead
      role_ids = mkOption {
        type = listOf string;
        
        description = "- (Required) Array of account role IDs that you want to assign to a member.";
      };
    }; }));
  };

  config =
    let
      result = flip mapAttrs
        config.cloudflare.resource.account_member
          (key: value:
          let
            filteredValues = filterAttrs (key: _: key != "extraConfig") value;
            extraConfig = value.extraConfig;
          in
            filteredValues // extraConfig);
    in
      mkIf ( config.cloudflare.enable && length (builtins.attrNames result) != 0 ) {
        resource.cloudflare_account_member = result;
      };
}

