{
  description = "terranix flake";

  inputs.nixpkgs.url = "github:nixos/nixpkgs";
  inputs.flake-utils.url = "github:numtide/flake-utils";
  inputs.terranix-examples.url = "github:terranix/terranix-examples";
  inputs.bats-support = {
    url = "github:bats-core/bats-support";
    flake = false;
  };
  inputs.bats-assert = {
    url = "github:bats-core/bats-assert";
    flake = false;
  };

  outputs = { self, nixpkgs, flake-utils, terranix-examples, bats-support, bats-assert }:
    (flake-utils.lib.eachDefaultSystem (system:
      let pkgs = nixpkgs.legacyPackages.${system};
      in {

        packages.terranix = pkgs.callPackage ./default.nix {
          # as long nix flake is an experimental feature;
          nix = pkgs.nixUnstable;
        };
        defaultPackage = self.packages.${system}.terranix;

        # nix develop
        devShell = pkgs.mkShell {
          buildInputs =
            [ pkgs.terraform_0_15 self.packages.${system}.terranix ];
        };

        # nix run
        defaultApp = self.apps.${system}.test;
        # nix run ".#test"
        apps.test =
          let
            createTest = testimport:
              let
                tests = import testimport {
                  inherit pkgs;
                  inherit (pkgs) lib;
                  terranix = self.packages.${system}.terranix;
                };
                batsScripts = map
                  (text: pkgs.writeText "test" ''
                    load '${bats-support}/load.bash'
                    load '${bats-assert}/load.bash'
                    ${text}
                  '')
                  tests;
                allBatsScripts =
                  map (file: "${pkgs.bats}/bin/bats ${file}") batsScripts;
              in
              pkgs.writeScript "test-script"
                (nixpkgs.lib.concatStringsSep "\n" allBatsScripts);
            allTests = [ (createTest ./tests/test.nix) ];
          in
          pkgs.writers.writeBashBin "check" ''
            set -e
            ${nixpkgs.lib.concatStringsSep "\n" allTests}
          '';

      })) // {

      lib.terranixConfiguration =
        { system
        , pkgs ? builtins.getAttr system nixpkgs.outputs.legacyPackages
        , extraArgs ? { }
        , modules ? [ ]
        , strip_nulls ? true
        }:
        let
          terranix_args = {
            inherit pkgs extraArgs strip_nulls;
            terranix_config.imports = modules;
          };
          terranixCore = import ./core/default.nix terranix_args;
        in
        pkgs.writeTextFile {
          name = "config.tf.json";
          text = builtins.toJSON terranixCore.config;
        };

      lib.buildTerranix = nixpkgs.lib.warn "buildTerranix will be removed in 3.0.0 use terranixConfiguration instead"
        ({ pkgs, terranix_config, ... }@terranix_args:
          let terranixCore = import ./core/default.nix terranix_args;
          in pkgs.writeTextFile {
            name = "config.tf.json";
            text = builtins.toJSON terranixCore.config;
          });

      lib.buildOptions =
        { pkgs
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
        };

      # nix flake init -t github:terranix/terranix#flake
      templates = terranix-examples.templates;
      # nix flake init -t github:terranix/terranix
      defaultTemplate = terranix-examples.defaultTemplate;
    };
}
