#
# core sturcture
#

{ lib, ... }:

with lib;

{
  options = {
    variable = mkOption {
      type = with types; attrsOf attrs;
      default = { dummy = { value = "I'm a dummy"; }; };
      description = "foo";
    };
    provider = mkOption {
      type = with types; attrsOf attrs;
      default = {};
      description = "foo";
    };
    resource = mkOption {
      type = with types; attrsOf attrs;
      default = {};
      description = "foo";
    };
    output = mkOption {
      type = with types; attrsOf attrs;
      default = { dummy = { value = "I'm a dummy"; }; };
      description = "outputs";
    };
  };
}
