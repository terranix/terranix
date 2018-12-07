{ lib, ... }:
with lib;
{
  imports = [
    ./provider.nix
    ./server.nix
    ./volume.nix
  ];

  options.hetzner = {
    enable = mkEnableOption "enable hetzner.provider";
  };

}