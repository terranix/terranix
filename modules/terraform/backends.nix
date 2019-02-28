{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.backend;

  localSubmodule =
    types.submodule {
      options = {
        path = mkOption {
          type    = with types; str;
          description = ''
            path to the state file
          '';
        };
      };
    };

  s3Submodule =
    types.submodule {
      options = {
        bucket = mkOption {
          type    = with types; str;
          description = ''
            bucket name
          '';
        };
        key = mkOption {
          type    = with types; str;
          description = ''
            path to the state file in the bucket
          '';
        };
        region = mkOption {
          type    = with types; str;
          description = ''
            region of the bucket
          '';
        };
      };
    };

  etcdSubmodule =
    types.submodule {
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
    };

in {

  options.backend.local = mkOption {
    default = null;
    type = with types; nullOr localSubmodule;
    description = ''
      local backend
      https://www.terraform.io/docs/backends/types/local.html
    '';
  };

  options.backend.s3 = mkOption {
    default = null;
    type = with types; nullOr s3Submodule;
    description = ''
      s3 backend
      https://www.terraform.io/docs/backends/types/s3.html
    '';
  };

  options.backend.etcd = mkOption {
    default = null;
    type = with types; nullOr etcdSubmodule;
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
