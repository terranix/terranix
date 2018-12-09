#
# core sturcture
#

{ lib, ... }:

with lib;

{
  options = {
    variable = mkOption {
      type = with types; attrsOf attrs;
      default = {};
      description = "foo";
    };
    provider = mkOption {
      type = with types; attrsOf attrs;
      default = {};
      description = "provider, basically APIs";
    };
    data = mkOption {
      type = with types; attrsOf attrs;
      default = {};
      description = "data objects, basically querries";
    };
    resource = mkOption {
      type = with types; attrsOf attrs;
      default = {};
      description = "resources, basically commands";
    };
    output = mkOption {
      type = with types; attrsOf attrs;
      default = {};
      description = "outputs";
    };
  };
}
