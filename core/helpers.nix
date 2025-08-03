# override to the standard nixpkgs lib, adding
# terranix-related helpers
pkgs: self: super: {
  tf = rec {
    # escape ${} to create a terraform reference string
    ref = ref: "\${${ref}}";

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

    # Apply function to all strings in an attrset recursively through lists as well
    # Converts stringlike types to string before (derivations become paths for example)
    mapStringsDeep =
      function: value:
      if super.isStringLike value then
        function (toString value)
      else if super.isAttrs value then
        super.mapAttrs (name: mapStringsDeep function) value
      else if super.isList value then
        map (mapStringsDeep function) value
      else
        value;

    # Escapes strings so variables aren't interpolated with ${} and %{}
    escapeInterpolation =
      value:
      super.replaceStrings
        [
          # Nix and tf shares this escape pattern
          "\${"
          # tf also interpolates %{}
          "%{"
        ]
        [
          "$\${"
          "%%{"
        ]
        value;

    # Escape all strings in an attrset so tf can parse it properly
    escapeInterpolationDeep = attrs: mapStringsDeep escapeInterpolation attrs;
  };

  # top-level aliases for backwards compatibility
  tfRef = self.tf.ref;
}
