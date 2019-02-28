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
      https://www.terraform.io/docs/backends/types/local.html
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
      https://www.terraform.io/docs/backends/types/s3.html
    '';
  };

  options.backend.etcd = mkOption {
    default = null;
    type    = with types; nullOr (submodule {
      options = {
        path = mkOption {
          type    = with types; str;
          description = ''
            The path where to store the state
          '';
        };
        endpoints = mkOption {
          # todo : type should be listOf str
          type    = with types; str;
          description = ''
            A space-separated list of the etcd endpoints
          '';
        };
        username = mkOption {
          default = null;
          type    = with types; nullOr str;
          description = ''
            the username
          '';
        };
        password = mkOption {
          default = null;
          type    = with types; nullOr str;
          description = ''
            the password
          '';
        };
      };
    });

    description = ''
      etcd backend
      https://www.terraform.io/docs/backends/types/etcd.html
    '';
  };



  config =
    let
      backends = [ "local" "s3" "etcd" ];
      notNull = element: ! ( isNull element );
      rule = backend:
        mkIf (cfg."${backend}" != null) { terraform."backend"."${backend}" = cfg."${backend}"; };
      backendConfigs = map (backend: cfg."${backend}") backends;
    in
      mkAssert ( length ( filter notNull backendConfigs ) < 2 )
        "You defined multiple backends, stick to one!"
        (mkMerge (map rule backends));

}
