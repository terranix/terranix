{ ... }:
{
  perSystem =
    { config
    , lib
    , pkgs
    , ...
    }:
    let
      # vulnix reads .drv files, so instantiating is enough; asking for the
      # outputs would also build them, and mkShell derivations cannot be built.
      drvPath = package: builtins.unsafeDiscardOutputDependency package.drvPath;

      # --requisites (vulnix's default) walks the build-time closure, which
      # subsumes the runtime closure of each of these.
      scanTargets = map drvPath [
        config.packages.terranix
        config.packages.manPages
        # Accounts for about half the whitelist: shellcheck and prettier pull in
        # Haskell and node package sets that vulnix matches on name alone, so
        # the library named vault collects HashiCorp Vault CVEs.
        config.devShells.default
      ];
      # After bumping nixpkgs, re-triage with
      #   nix run .#vulnix -- --write-whitelist dev/vulnix-whitelist.toml
      # and review the diff: --write-whitelist accepts every current match, so
      # it silently absolves new CVEs unless a human reads what it added.
      whitelist = ./vulnix-whitelist.toml;
    in
    {
      apps.vulnix.program = pkgs.writeShellApplication {
        name = "vulnix";
        runtimeInputs = [ pkgs.vulnix ];
        text = ''
          exec vulnix \
            --whitelist ${whitelist} \
            ${lib.concatStringsSep " " scanTargets} \
            "$@"
        '';
      };
    };
}
