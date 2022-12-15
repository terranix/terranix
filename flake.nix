{
  description = "terranix flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
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

  outputs =
    { self
    , nixpkgs
    , flake-utils
    , terranix-examples
    , bats-support
    , bats-assert
    }:
    (flake-utils.lib.eachDefaultSystem (system:
    let pkgs = nixpkgs.legacyPackages.${system};
    in {

      # nix build
      packages.terranix = pkgs.callPackage ./default.nix {
        # as long nix flake is an experimental feature;
        nix = pkgs.nixUnstable;
      };
      # nix build "manpages"
      packages.manpages = (pkgs.callPackage ./doc/default.nix { }).manPages;
      packages.default = self.packages.${system}.terranix;
      # TODO: Legacy attribute, drop soon
      defaultPackage = self.packages.${system}.default;

      # nix develop
      devShells.default = pkgs.mkShell {
        buildInputs =
          [ pkgs.terraform_0_15 self.packages.${system}.terranix ];
      };
      # TODO: Legacy attribute, drop soon
      devShell = self.devShells.${system}.default;

      # nix run
      apps.default = self.apps.${system}.test;
      # TODO: Legacy attribute, drop soon
      defaultApp = self.apps.${system}.default;
      # nix run ".#test"
      apps.test =
        let
          tests = import ./tests/test.nix {
            inherit pkgs;
            inherit (pkgs) lib;
            terranix = self.packages.${system}.terranix;
          };
          testFile = pkgs.writeText "test" ''
            load '${bats-support}/load.bash'
            load '${bats-assert}/load.bash'
            ${pkgs.lib.concatStringsSep "\n" tests}
          '';
        in
        {
          type = "app";
          program = toString (pkgs.writeShellScript "test" ''
            set -e
            echo "running terranix tests" | ${pkgs.boxes}/bin/boxes -d ian_jones -a c
            #cat ${testFile}
            ${pkgs.bats}/bin/bats ${testFile}
          '');
        };
      # nix run ".#docs"
      apps.doc = self.apps.${system}.docs;
      apps.docs = {
        type = "app";
        program = toString (pkgs.writeShellScript "docs" ''
          set -e
          export PATH=${pkgs.pandoc}/bin:$PATH
          ${pkgs.gnumake}/bin/make --always-make --directory=doc
          nix build ".#manpages"
          cp -r result/share .
          chmod -R 755 ./share
          rm result
        '');
      };

    })) // {

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
          in pkgs.writeTextFile {
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
      templates = terranix-examples.templates // {
        default = terranix-examples.defaultTemplate;
      };
      # nix flake init -t github:terranix/terranix

      # TODO: Legacy attribute, drop soon
      defaultTemplate = self.templates.default;
    };
}
