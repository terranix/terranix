
# automatically generated, you should change resource_account_member.json instead
# documentation : https://www.terraform.io/docs/providers/cloudflare/r/account_member.html
{ config, lib, ... }:
with lib;
with types;
{
  options.cloudflare.resource.account_member = mkOption {
    default = {};
    description = "";
    type = with types; attrsOf ( submodule {
      options = {
      # internal object that should not be overwritten.
      # used to generate references
      "_ref" = mkOption {
        type = with types; string;
        default = "cloudflare.account_member";
        description = "";
      };

      # automatically generated, change the json file instead
      email_address = mkOption {
        type = nullOr string;
        default = null;
        description = "- (Required) The email address of the user who you wish to manage. Note: Following creation, this field becomes read only via the API and cannot be updated.";
      };
      # automatically generated, change the json file instead
      role_ids = mkOption {
        type = nullOr string;
        default = null;
        description = "- (Required) Array of account role IDs that you want to assign to a member.";
      };
    }; });
  };

  config = mkIf config.cloudflare.enable {
    resource.cloudflare_account_member = config.cloudflare.resource.account_member;
  };

}

