cat api.json | jq --raw-output '. | "
{ options.<name1>.<name> = {
  default = {};
  description = ''<name1>'';
  type = with types; attrsOf (submodule ( {name, ... }: {

\( .arguments | map(
"
    \( .key ) = mkOption {
      type    = with types; string;
      description = ''
	\( .description )
      '';
    };"
) | join("\n") )

  }));
  }
}
"'
