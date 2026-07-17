{ ... }:
{
  perSystem =
    { pkgs
    , ...
    }:
    {
      formatter = pkgs.treefmt;
    };
}
