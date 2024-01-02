{
  description = "terranix flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";

    systems.url = "github:nix-systems/default";

    terranix-examples.url = "github:terranix/terranix-examples";

    bats-support = {
      url = "github:bats-core/bats-support";
      flake = false;
    };

    bats-assert = {
      url = "github:bats-core/bats-assert";
      flake = false;
    };
  };

  outputs = inputs @ { self, flake-parts, nixpkgs, ... }:

    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
      ];

      systems = import inputs.systems;

      perSystem =
        { config
        , self'
        , pkgs
        , system
        , ...
        }: {
          packages = rec {
            default = terranix;

            terranix = pkgs.callPackage ./default.nix {
              nix = pkgs.nixUnstable;
            };

            inherit (pkgs.callPackage ./doc/default.nix { }) manPages;
          };

          devShells.default = pkgs.mkShell {
            buildInputs = with pkgs;
              [
                terraform_0_15
                self'.packages.terranix
                treefmt
                nixfmt
                shfmt
                shellcheck
                nodePackages.prettier
              ];
          };

          apps = rec {
            test.program = pkgs.writeShellApplication {
              name = "test";
              runtimeInputs = with pkgs; [ boxes bats ];
              text =
                let
                  tests = import ./tests/test.nix {
                    inherit nixpkgs;
                    inherit pkgs;
                    inherit (pkgs) lib;
                    terranix = self'.packages.terranix;
                  };
                  testFile = pkgs.writeText "test" ''
                    load '${inputs.bats-support}/load.bash'
                    load '${inputs.bats-assert}/load.bash'
                    ${pkgs.lib.concatStringsSep "\n" tests}
                  '';
                in
                ''
                  echo "running terranix tests" | boxes -d ian_jones -a c
                  #cat ${testFile}
                  bats ${testFile}
                '';
            };
            # nix run ".#docs"
            doc = docs;
            docs.program = pkgs.writeShellApplication {
              name = "docs";
              runtimeInputs = with pkgs; [ pandoc gnumake nix ];
              text = ''
                make --always-make --directory=doc
                nix build ".#manpages"
                cp -r result/share .
                chmod -R 755 ./share
                rm result
              '';
            };
          };

          formatter = pkgs.treefmt;

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
                  del(.data) |
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
                      del(.data) |
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

        # nix flake init -t github:terranix/terranix#flake
        templates = inputs.terranix-examples.templates // {
          default = inputs.terranix-examples.defaultTemplate;
        };
      };
    };
}
