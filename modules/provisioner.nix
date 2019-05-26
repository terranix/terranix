{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.provisioner;

in {

  options.provisioner = {
    privateKeyFile = mkOption {
      type = with types; str;
      description = ''
        private key filename for ssh access for provioning
        see https://www.terraform.io/docs/provisioners/connection.html
      '';
    };
  };

}
