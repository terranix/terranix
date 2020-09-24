{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.testing-terranix;

in {

  options.testing-terranix = {
    enable = mkEnableOption "enable testing-terranix";
  };

  config = mkIf cfg.enable {
    
  };
}
