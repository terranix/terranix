{ config, lib, ... }:
with lib;
{

  options.hetzner = {
    enable = mkEnableOption "enable hetzner.provider";
  };

}
