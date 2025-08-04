{
  description = "terranix flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";

    systems.url = "github:nix-systems/default";

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
  };

  outputs = inputs @ { self, flake-parts, nixpkgs, ... }:

    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        ./flake-module.nix
        flake-parts.flakeModules.partitions
      ];

      systems = import
        inputs.systems;

      partitions.dev = {
        extraInputsFlake = ./dev;
        module.imports = [ ./dev/flake-module.nix ];
      };

      partitionedAttrs = {
        apps = "dev";
        devShells = "dev";
        formatter = "dev";
        templates = "dev";
      };

      perSystem =
        { pkgs
        , system
        , ...
        }:
        {
          _module.args.pkgs = import inputs.nixpkgs {
            inherit system;
            config = {
              allowUnfree = true;
            };
          };
          packages = rec {
            default = terranix;

            terranix = pkgs.callPackage ./default.nix {
              nix = pkgs.nixVersions.git;
            };

            inherit (pkgs.callPackage ./doc/default.nix { }) manPages;
          };
        };

      flake = {
        # terraformConfiguration ast, if you want to run
        # terranix in the repl.
        lib.terranixConfigurationAst =
          { system ? ""
          , pkgs ? builtins.getAttr system nixpkgs.outputs.legacyPackages
          , extraArgs ? { }
          , modules ? [ ]
          , strip_nulls ? true
          }:
          import ./core/default.nix {
            inherit pkgs extraArgs strip_nulls;
            terranix_config.imports = modules;
          };

        # terranixOptions ast, if you want to run
        # terranix in a repl.
        lib.terranixOptionsAst =
          { system ? ""
          , pkgs ? builtins.getAttr system nixpkgs.outputs.legacyPackages
          , modules ? [ ]
          , moduleRootPath ? "/"
          , urlPrefix ? ""
          , urlSuffix ? ""
          }:
          import ./lib/terranix-doc-json.nix {
            terranix_modules = modules;
            inherit moduleRootPath urlPrefix urlSuffix pkgs;
          };

        # create a config.tf.json.
        # you have to either have to name a system or set pkgs.
        lib.terranixConfiguration =
          { system ? ""
          , pkgs ? builtins.getAttr system nixpkgs.outputs.legacyPackages
          , extraArgs ? { }
          , modules ? [ ]
          , strip_nulls ? true
          }:
          let
            terranixCore = import ./core/default.nix {
              inherit pkgs extraArgs strip_nulls;
              terranix_config.imports = modules;
            };
          in
          (pkgs.formats.json { }).generate "config.tf.json" terranixCore.config;

        lib.mkTerranixOutputs = import ./core/terraform-invocs.nix;

        # create a options.json.
        # you have to either have to name a system or set pkgs.
        lib.terranixOptions =
          { system ? ""
          , pkgs ? builtins.getAttr system nixpkgs.outputs.legacyPackages
          , modules ? [ ]
          , moduleRootPath ? "/"
          , urlPrefix ? ""
          , urlSuffix ? ""
          }:
          let
            terranixOptions = import ./lib/terranix-doc-json.nix {
              terranix_modules = modules;
              inherit moduleRootPath urlPrefix urlSuffix pkgs;
            };
          in
          pkgs.runCommand "terranix-options" { }
            ''
              cat ${terranixOptions}/options.json | \
                ${pkgs.jq}/bin/jq '
                  del(.ephemeral) |
                  del(.data) |
                  del(.import) |
                  del(.locals) |
                  del(.module) |
                  del(.output) |
                  del(.provider) |
                  del(.resource) |
                  del(.terraform) |
                  del(.variable)
                  ' > $out
            '';

        # deprecated
        lib.buildTerranix = nixpkgs.lib.warn "buildTerranix will be removed in 3.0.0 use terranixConfiguration instead"
          ({ pkgs, terranix_config, ... }@terranix_args:
            let terranixCore = import ./core/default.nix terranix_args;
            in
            pkgs.writeTextFile {
              name = "config.tf.json";
              text = builtins.toJSON terranixCore.config;
            });

        # deprecated
        lib.buildOptions =
          nixpkgs.lib.warn "buildOptions will be removed in 3.0.0 use terranixOptions instead"
            ({ pkgs
             , terranix_modules
             , moduleRootPath ? "/"
             , urlPrefix ? ""
             , urlSuffix ? ""
             , ...
             }@terranix_args:
              let
                terranixOptions = import ./lib/terranix-doc-json.nix terranix_args;
              in
              pkgs.stdenv.mkDerivation {
                name = "terranix-options";
                src = self;
                installPhase = ''
                  mkdir -p $out
                  cat ${terranixOptions}/options.json \
                    | ${pkgs.jq}/bin/jq '
                      del(.ephemeral) |
                      del(.data) |
                      del(.import) |
                      del(.locals) |
                      del(.module) |
                      del(.output) |
                      del(.provider) |
                      del(.resource) |
                      del(.terraform) |
                      del(.variable)
                      ' > $out/options.json
                '';
              });
      };
    };
}
