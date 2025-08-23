{ inputs, ... }:

{
  perSystem =
    { config
    , pkgs
    , ...
    }:
    {
      devShells.default = pkgs.mkShell {
        buildInputs = with pkgs;
          [
            terraform
            config.packages.terranix
            treefmt
            nixpkgs-fmt
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
              tests = import ../tests/test.nix {
                inherit (inputs) nixpkgs;
                inherit (inputs.nixpkgs) lib;
                inherit pkgs;
                terranix = config.packages.terranix;
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
            nix build ".#manPages"
            cp -r result/share .
            chmod -R 755 ./share
            rm result
          '';
        };
      };

      formatter = pkgs.treefmt;
    };

  # nix flake init -t github:terranix/terranix#flake
  flake.templates = inputs.terranix-examples.templates // {
    default = inputs.terranix-examples.defaultTemplate;
  };
}
