{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.backend;

in {

  options.backend.local = mkOption {
    default = null;
    type    = with types; nullOr (submodule {
      options = {
        path = mkOption {
          type    = with types; string;
          description = ''
            path to the state file
          '';
        };
      };
    });

    description = ''
      local backend
    '';
  };

  options.backend.s3 = mkOption {
    default = null;
    type    = with types; nullOr (submodule {
      options = {
        bucket = mkOption {
          type    = with types; string;
          description = ''
            bucket name
          '';
        };
        key = mkOption {
          type    = with types; string;
          description = ''
            path to the state file in the bucket
          '';
        };
        region = mkOption {
          type    = with types; string;
          description = ''
            region of the bucket
          '';
        };
      };
    });
    description = ''
      s3 backend
    '';
  };

  config =
    let
      notNull = element: ! ( isNull element );
    in
      mkAssert ( length ( filter notNull [ cfg.local cfg.s3 ] ) < 2 )
        "you defined to backends which will not work stick to one"
        (mkMerge [
          ( mkIf (cfg.local != null) { terraform."backend".local = cfg.local; })
          ( mkIf (cfg.s3 != null)    { terraform."backend".s3    = cfg.s3; })
        ]);

}
