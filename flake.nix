{
  description = "terranix flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";

    systems.url = "github:nix-systems/default";

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    import-tree.url = "github:vic/import-tree";
  };

  outputs = inputs @ { flake-parts, import-tree, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } ({ self, flake-parts-lib, ... }:
      let
        # Kept out of the import-tree'd ./flake: it's a `{ terranix }:` function,
        # not a plain module, so it needs importApply to bind terranix and keep
        # its _file. https://flake.parts/define-module-in-separate-file.html
        flakeModule = flake-parts-lib.importApply ./flake-module.nix { terranix = self; };
      in
      {
        imports = [
          (import-tree ./flake)
          flakeModule
        ];

        flake.flakeModule = flakeModule;
      });
}
