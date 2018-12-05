{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.hetzner;

in {

  options.hetzner.server = mkOption {
    type    = with types; attrsOf attrs;
    description = ''
      create a server config
    '';
 };

  config = mkIf cfg.enable {
    resource.hcloud_server = cfg.server;
  };
}
