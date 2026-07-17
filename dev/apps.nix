{ inputs, ... }:
{
  perSystem =
    { config
    , pkgs
    , ...
    }:
    {
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
          runtimeInputs = with pkgs; [ pandoc gnumake ];
          text = ''
            make --always-make --directory=doc
            cp -r ${config.packages.manPages}/share .
            chmod -R 755 ./share
          '';
        };
      };
    };
}
