# manage backend configurations and terraform_remote_state configurations
{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.backend;

  localSubmodule = types.submodule {
    options = {
      path = mkOption {
        type = with types; str;
        description = ''
          path to the state file
        '';
      };
    };
  };

  s3Submodule = types.submodule {
    options = {
      bucket = mkOption {
        type = with types; str;
        description = ''
          bucket name
        '';
      };
      key = mkOption {
        type = with types; str;
        description = ''
          path to the state file in the bucket
        '';
      };
      region = mkOption {
        type = with types; str;
        description = ''
          region of the bucket
        '';
      };
    };
  };

  etcdSubmodule = types.submodule {
    options = {
      path = mkOption {
        type = with types; str;
        description = ''
          The path where to store the state
        '';
      };
      endpoints = mkOption {
        # todo : type should be listOf str
        type = with types; str;
        description = ''
          A space-separated list of the etcd endpoints
        '';
      };
      username = mkOption {
        default = null;
        type = with types; nullOr str;
        description = ''
          the username
        '';
      };
      password = mkOption {
        default = null;
        type = with types; nullOr str;
        description = ''
          the password
        '';
      };
    };
  };

in
{

  options.backend.local = mkOption {
    default = null;
    type = with types; nullOr localSubmodule;
    description = ''
      local backend
      https://www.terraform.io/docs/backends/types/local.html
    '';
  };

  options.remote_state.local = mkOption {
    default = { };
    type = with types; attrsOf localSubmodule;
    description = ''
      local remote state
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

  options.remote_state.s3 = mkOption {
    default = { };
    type = with types; attrsOf s3Submodule;
    description = ''
      s3 remote state
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

  options.remote_state.etcd = mkOption {
    default = { };
    type = with types; attrsOf etcdSubmodule;
    description = ''
      etcd remote state
      https://www.terraform.io/docs/backends/types/etcd.html
    '';
  };

  config =
    let
      backends = [ "local" "s3" "etcd" ];
      notNull = element: !(isNull element);

      backendConfigurations =
        let
          rule = backend:
            mkIf (config.backend."${backend}" != null) {
              terraform."backend"."${backend}" = config.backend."${backend}";
            };

          backendConfigs = map (backend: config.backend."${backend}") backends;
        in
        mkAssert (length (filter notNull backendConfigs) < 2)
          "You defined multiple backends, stick to one!"
          (mkMerge (map rule backends));

      remoteConfigurations =
        let
          backendConfigs = map (backend: config.remote_state."${backend}") backends;
          allRemoteStates = flatten
            (map attrNames (filter (element: element != { }) backendConfigs));
          uniqueRemoteStates = unique allRemoteStates;

          remote = backend:
            mkIf (config.remote_state."${backend}" != { }) {
              data."terraform_remote_state" = mapAttrs
                (name: value: {
                  config = value;
                  backend = "${backend}";
                })
                config.remote_state."${backend}";
            };
        in
        mkAssert (length allRemoteStates == length uniqueRemoteStates)
          "You defined multiple terraform_states with the same name!"
          (mkMerge (map remote backends));
    in
    mkMerge [ backendConfigurations remoteConfigurations ];

}
