#
# core sturcture
#

{ lib, ... }:

with lib;

{
  options = {
    data = mkOption {
      type = with types; attrsOf attrs;
      default = {};
      description = ''
        data objects, basically queries
        https://www.terraform.io/docs/configuration/data-sources.html
      '';
    };
    locals = mkOption {
      type = with types; attrsOf attrs;
      default = {};
      description = ''
        locals block, where you can define variables in terraform.
        like modules this is terraform intern and terranix has better ways.
        https://www.terraform.io/docs/configuration/locals.html
      '';
    };
    module = mkOption {
      type = with types; attrsOf attrs;
      default = {};
      description = ''
        A module is a container for multiple resources that are used together.
        This is the terraform internal module system, and has nothing to
        do with the module system of terranix or nixos.
        https://www.terraform.io/docs/configuration/modules.html
      '';
    };
    output = mkOption {
      type = with types; attrsOf attrs;
      default = {};
      description = ''
        outputs use full in combination with terraform_remote_state
        https://www.terraform.io/docs/configuration/outputs.html
      '';
    };
    provider = mkOption {
      type = with types; attrsOf attrs;
      default = {};
      description = ''
        provider, basically an API
        https://www.terraform.io/docs/configuration/providers.html
      '';
    };
    resource = mkOption {
      type = with types; attrsOf attrs;
      default = {};
      description = ''
        resources, basically commands
        https://www.terraform.io/docs/configuration/resources.html
      '';
    };
    terraform = mkOption {
      type = with types; attrsOf attrs;
      default = {};
      description = ''
        terraform configuration, mainly for backends
        https://www.terraform.io/docs/configuration/terraform.html
      '';
    };
    variable = mkOption {
      type = with types; attrsOf attrs;
      default = {};
      description = ''
        Variables for input.
        Usually in terraform modules or to ask for API tokens.
        https://www.terraform.io/docs/configuration/variables.html
      '';
    };
  };
}
