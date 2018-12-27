# terranix library
# ----------------
# in here are all the code that is terranix

{ stdenv, writeShellScriptBin, pandoc, ... }:
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

  manpage = version: stdenv.mkDerivation rec {
    inherit version;
    name = "terranix-manpage";
    src = ./doc;

    installPhase = ''
      mkdir -p $out/share/man/man1
      
      cat <( echo "% TerraNix" && \
        echo "% Ingolf Wagner" && \
        echo "% $( date +%Y-%m-%d )" && \
        cat $src/man_*.md ) \
        | ${pandoc}/bin/pandoc - -s -t man \
        > $out/share/man/man1/terranix.1
    '';

  };


}
