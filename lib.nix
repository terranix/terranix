{ writeShellScriptBin }:
{

  terranix = writeShellScriptBin "terranix" ''
    FILE=${"$"}{1:-config.nix}

    nix-instantiate --eval --strict --json \
      -I config=$FILE \
      ${toString ./core/default.nix}
  '';

  terranixTrace = writeShellScriptBin "terranix-trace" ''
    FILE=${"$"}{1:-config.nix}

    nix-instantiate --eval --strict --json \
      -I config=$FILE \
      --show-trace \
      ${toString ./core/default.nix}
  '';

}
