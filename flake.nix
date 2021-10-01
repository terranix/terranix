{
  description = "terranix flake";

  inputs.nixpkgs.url = "github:nixos/nixpkgs";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils }:
    (flake-utils.lib.eachSystem [ "x86_64-darwin" "x86_64-linux" ] (system:
      let pkgs = nixpkgs.legacyPackages.${system};
      in {

        packages.terranix = pkgs.callPackage ./default.nix { };
        defaultPackage = self.packages.${system}.terranix;

        checks.test = let
          createTest = testimport:
            let
              test = import testimport {
                inherit pkgs;
                inherit (pkgs) lib;
                terranix = self.packages.${system}.terranix;
              };
              batsScripts = map (text: pkgs.writeText "test" text) test;
              allScripts =
                map (file: "${pkgs.bats}/bin/bats ${file}") batsScripts;
            in pkgs.writeScript "test-script"
            (nixpkgs.lib.concatStringsSep "\n" allScripts);
          allTests = [ (createTest ./tests/test.nix) ];
        in pkgs.writeShellScriptBin "check" ''
          set -e
          ${nixpkgs.lib.concatStringsSep "\n" allTests}
        '';

      })) // {
        lib.buildTerranix = { pkgs, terranix_config, ... }@terranix_args:
          let terranixCore = import ./core/default.nix terranix_args;
          in pkgs.writeTextFile {
            name = "terraform-config";
            text = builtins.toJSON terranixCore.config;
            executable = false;
            destination = "/config.tf.json";
          };

        templates.terranix = {
          path = ./examples/flake;
          description = "terranix flake example";
        };
        templates.defaultTemplate = self.templates.terranix;
      };
}
