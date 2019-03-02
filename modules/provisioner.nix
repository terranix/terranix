{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.provisioner;

in {

  options.provisioner = {
    privateKey = mkOption {
      type = with types; str;
      description = ''
        private key for ssh access for provioning
        see https://www.terraform.io/docs/provisioners/connection.html
      '';
    };
  };

}
