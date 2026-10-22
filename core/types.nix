# types shared by the core options and the generated provider modules
lib:

with lib;

rec {
  # a block from `withReference` used as a value, e.g. `token = config.variable.token`
  reference = mkOptionType {
    name = "reference";
    check = v: isAttrs v && v ? __toString;
  };

  valueType =
    with types;
    nullOr
      (oneOf [
        bool
        int
        float
        (coercedTo reference toString str)
        (attrsOf valueType)
        (listOf valueType)
      ])
    // {
      description = "bool, int, float, str or reference";
      emptyValue.value = { };
    };
}
