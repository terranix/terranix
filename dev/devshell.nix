{ ... }:
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
            prettier
          ];
      };
    };
}
