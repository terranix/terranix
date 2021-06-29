{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
    terranix = {
      url = "github:mrVanDalo/terranix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, flake-utils, terranix }:
    flake-utils.lib.eachDefaultSystem (
      system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
          buildTerranix = terranix.lib.buildTerranix;
          name = "exampleconfig";
        in
          rec {
            packages = {
              ${name} = buildTerranix {
                inherit pkgs;
                terranix_config = {};
              };
            };

            defaultPackage = packages.${name};
          }
    );
}
