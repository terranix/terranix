#
# core sturcture
#

{ lib, ... }:

with lib;

{ 
  options = {
    variable = mkOption {
      type = with types; attrsOf attrs;
      default = [];
      description = "foo";
    };
    provider = mkOption {
      type = with types; attrsOf attrs;
      default = [];
      description = "foo";
    };
    resource = mkOption {
      type = with types; attrsOf attrs;
      default = {};
      description = "foo";
    };
  };
}
