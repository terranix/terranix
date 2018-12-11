
# automatically generated, you should change resource_branch_protection.json instead
# documentation : https://www.terraform.io/docs/providers/github/r/branch_protection.html
{ config, lib, ... }:
with lib;
with types;
{
  options.github.resource.branch_protection = mkOption {
    default = {};
    description = "";
    type = with types; attrsOf ( submodule ( { name, ... }: {
      options = {
      # internal object that should not be overwritten.
      # used to generate references
      "_ref" = mkOption {
        type = with types; string;
        default = "github_branch_protection.${name}";
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
        description = "- (Required) The GitHub repository name.";
      };
      # automatically generated, change the json file instead
      branch = mkOption {
        type = nullOr string;
        default = null;
        description = "- (Required) The Git branch to protect.";
      };
      # automatically generated, change the json file instead
      enforce_admins = mkOption {
        type = nullOr string;
        default = null;
        description = "- (Optional) Boolean, setting this to enforces status checks for repository administrators.";
      };
      # automatically generated, change the json file instead
      required_status_checks = mkOption {
        type = nullOr string;
        default = null;
        description = "- (Optional) Enforce restrictions for required status checks. See below for details.";
      };
      # automatically generated, change the json file instead
      required_pull_request_reviews = mkOption {
        type = nullOr string;
        default = null;
        description = "- (Optional) Enforce restrictions for pull request reviews. See below for details.";
      };
      # automatically generated, change the json file instead
      restrictions = mkOption {
        type = nullOr string;
        default = null;
        description = "- (Optional) Enforce restrictions for the users and teams that may push to the branch. See below for details.";
      };
    }; }));
  };

  config =
    let
      result = flip mapAttrs
        config.github.resource.branch_protection
          (key: value:
          let
            filteredValues = filterAttrs (key: _: key != "extraConfig") value;
            extraConfig = value.extraConfig;
          in
            filteredValues // extraConfig);
    in
      mkIf ( config.github.enable && length (builtins.attrNames result) != 0 ) {
        resource.github_branch_protection = result;
      };
}

