{ lib, ... }:

with lib;

{
  options.users = mkOption {
    default = {};
    type = with types; attrsOf ( attrsOf ( submodule {
      options = {

        publicKey = mkOption {
          default = null;
          type = with types; nullOr string;
          description = ''
            public ssh key of user.
          '';
        };

      };
    }));

    example = {
      "admins" = {
        "mrVanDalo".publicKey = "ssh-rsa AAAAB3NzaC1yc2EAAAA..";
        "lassuls".publicKey = "ssh-rsa ABKAB3NzaC1yc2EAAAA..";
      };
    };

    description = ''
      user managment for servers. usually admins.
      A gloabal container of users which servers should
      pull from and allow access to them.
    '';

  };

}
