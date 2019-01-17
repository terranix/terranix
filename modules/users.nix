{ lib, ... }:

with lib;

{
  options.users = mkOption {
    default = {};

    type = with types; attrsOf ( attrsOf ( submodule {
      options = {

        ssh_key = mkOption {
          type    = with types; nullOr string;
          default = null;
          description = ''
            public key of user.
          '';
        };

      };
    }));

    example = {
      "admins" = {
        "mrVanDalo".ssh_key = "ssh-rsa AAAAB3NzaC1yc2EAAAA..";
        "lassuls".ssh_key = "ssh-rsa ABKAB3NzaC1yc2EAAAA..";
      };
    };

    description = ''
      user managment for servers. usually admins.
      A gloabal container of users which servers should
      pull from and allow access to them.
    '';

  };
}
