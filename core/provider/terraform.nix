{ config, lib, ... }:

with lib;

let

  cfg = config.terraform;

in {

  options.terraform = {
    enable = mkEnableOption "enable hetzner provider";
  };

}
