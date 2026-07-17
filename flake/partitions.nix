{ inputs, ... }:
{
  imports = [ inputs.flake-parts.flakeModules.partitions ];

  # The dev-only inputs and modules live in a second dendritic tree in /dev.
  partitions.dev = {
    extraInputsFlake = ../dev;
    module.imports = [
      ((inputs.import-tree.filterNot (p: builtins.baseNameOf p == "flake.nix")) ../dev)
    ];
  };

  partitionedAttrs = {
    apps = "dev";
    checks = "dev";
    devShells = "dev";
    formatter = "dev";
    templates = "dev";
  };
}
