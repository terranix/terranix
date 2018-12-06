{ lib, ... }:
with lib;
{
  imports = [ 
    ./provider.nix
  ];

  options.cloudflare = {
    enable = mkEnableOption "enable hetzner.provider";
  };

}