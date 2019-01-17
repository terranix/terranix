{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.remote_state;

in {

  options.remote_state = {
    # todo: work hier
    enable = mkEnableOption "enable remote_state";

    test = mkOption {
      type    = with types; str;
      default = "test";
      description = ''
        foo
      '';
    };
  };

  config = mkAssert (cfg.test == "test") "you are doing it wrong ${cfg.test}" {
    data."remote_state"."test" = {
      test= "yeah";
    };
  };
}
