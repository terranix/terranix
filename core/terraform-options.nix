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
      description = "data objects, basically queries";
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
      '';
    };
    output = mkOption {
      type = with types; attrsOf attrs;
      default = {};
      description = "outputs use full in combination with terraform_remote_state";
    };
    provider = mkOption {
      type = with types; attrsOf attrs;
      default = {};
      description = "provider, basically an API";
    };
    resource = mkOption {
      type = with types; attrsOf attrs;
      default = {};
      description = "resources, basically commands";
    };
    terraform = mkOption {
      type = with types; attrsOf attrs;
      default = {};
      description = "terraform configuration, mainly for backends";
    };
    variable = mkOption {
      type = with types; attrsOf attrs;
      default = {};
      description = ''
        Variables for input.
        Usually in terraform modules or to ask for API tokens.
      '';
    };

  };
}
