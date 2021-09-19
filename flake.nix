{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }: rec {
    lib = {
      buildTerranix = { pkgs, terranix_config, ... }@terranix_args: let
        terraform = import ./core/default.nix terranix_args;
        config_json = pkgs.writeTextFile {
          name = "terraform-config";
          text = builtins.toJSON terraform.config;
          executable = false;
          destination = "/config.tf.json";
        };
      in
        config_json;
    };
    templates.terranix = {
      path = ./examples/flake;
      description = "Terranix flake example";
    };
    templates.defaultTemplate = self.templates.terranix;
  };
}
