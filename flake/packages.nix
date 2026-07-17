{ inputs, ... }:
{
  perSystem =
    { pkgs
    , system
    , ...
    }:
    {
      _module.args.pkgs = import inputs.nixpkgs {
        inherit system;
        config = {
          allowUnfree = true;
        };
      };
      packages = rec {
        default = terranix;

        terranix = pkgs.callPackage ../default.nix {
          nix = pkgs.nixVersions.git;
        };

        inherit (pkgs.callPackage ../doc/default.nix { }) manPages;
      };
    };
}
