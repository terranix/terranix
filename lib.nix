# terranix library
# ----------------
# in here are all the code that is terranix

{ writeShellScriptBin }:
{

  terranix = writeShellScriptBin "terranix" ''
    FILE=${"$"}{1:-config.nix}

    if [ ! -f $FILE ]
    then
      echo "$FILE does not exist"
      exit 1
    fi

    nix-instantiate --eval --strict --json \
      -I config=$FILE \
      ${toString ./core/default.nix}
  '';

  terranixTrace = writeShellScriptBin "terranix-trace" ''
    FILE=${"$"}{1:-config.nix}

    if [ ! -f $FILE ]
    then
      echo "$FILE does not exist"
      exit 1
    fi

    nix-instantiate --eval --strict --json \
      -I config=$FILE \
      --show-trace \
      ${toString ./core/default.nix}
  '';

}
