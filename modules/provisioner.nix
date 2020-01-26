{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.provisioner;

in {

  options.provisioner = {
    privateKeyFile = mkOption {
      type = with types; str;
      description = ''
        PrivateKey for provisioning via ssh access
        see https://www.terraform.io/docs/provisioners/connection.html

        This is an agnostic option, option-authors should use this options
        to implement server provisioning.
      '';
      example = "~/.ssh/id_rsa";
    };
  };

}
