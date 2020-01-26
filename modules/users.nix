{ lib, ... }:

with lib;

{
  options.users = mkOption {
    default = {};
    type = with types; attrsOf ( attrsOf ( submodule {
      options = {

        publicKey = mkOption {
          default = null;
          type = with types; nullOr str;
          description = ''
            ssh public key of user
          '';
          example = "\${ file( ~/.ssh/id_rsa.pub ) }";
        };

      };
    }));

    description = ''
      User management. `users.group.username` is the path.
      All members in the `admins` group should be able to ssh to servers.

      This is an agnostic option, option-authors should use this options
      to implement server provisioning.
    '';

    example = {
      "admins" = {
        "mrVanDalo".publicKey = "ssh-rsa AAAAB3NzaC1yc2EAAAA..";
        "lassuls".publicKey = "ssh-rsa ABKAB3NzaC1yc2EAAAA..";
      };
    };

  };

}
