# override to the standard nixpkgs lib, adding
# terranix-related helpers
pkgs: self: super: {
  tf = {
    # escape ${} to create a terraform reference string
    ref = ref: "\${${ref}}";

    # module with typed options for a provider's resources and data sources,
    # e.g. `imports = [ (lib.tf.provider "hetznercloud_hcloud") ];`.
    # Takes a `pkgs.terraform-providers` name or package. Needs import-from-derivation.
    provider = provider:
      import ../providers/module.nix { inherit pkgs; lib = self; }
        (if builtins.isString provider then pkgs.terraform-providers.${provider} else provider);

    # easier way to reference terraform file
    file = path: "\${file(\"${path}\")}";

    # easier way to create templatefile() invocations
    # if used to set a variable, remember to wrap in `ref`
    template =
      { text ? ""
      , source ? ""
      , variables ? { }
      }:
        assert super.assertMsg (text == "" || source == "") "You must provide either 'text' or 'source' arguments";
        let
          template =
            if text != ""
            then pkgs.writeText "template.tftpl" text
            else source;
        in
        "templatefile(\"${template}\", ${builtins.toJSON variables})";
  };

  # top-level aliases for backwards compatibility
  tfRef = self.tf.ref;
}
