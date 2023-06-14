# override to the standard nixpkgs lib, adding
# terranix-related helpers
pkgs: self: super: {
  tf = {
    # escape ${} to create a terraform reference string
    ref = ref: "\${${ref}}";

    # easier way to create templatefile() invocations
    # if used to set a variable, remember to wrap in `ref`
    template =
    { text ? ""
    , source ? ""
    , variables ? ""
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
