# terranix library
# ----------------
# in here are all the code that is terranix

{ stdenv, writeShellScriptBin, pandoc, ... }:
{

  terranix = writeShellScriptBin "terranix" /* sh */ ''
  FILE=${"$"}{1:-./config.nix}

  if [ ! -f $FILE ]
  then
      echo "$FILE does not exist"
      exit 1
  fi

  TERRAFORM_JSON=$( nix-build \
      --no-out-link \
      --attr run \
      --quiet \
      --expr "
    with import <nixpkgs> {};
    let
      terranix_config = import $FILE { inherit pkgs; inherit (pkgs) lib; };
      terranix_data = import ${toString ./core/default.nix} { inherit terranix_config; };
      terraform_json = builtins.toJSON (terranix_data.config);
    in { run = pkgs.writeText \"config.tf.json\" terraform_json; }
  " )

  if [[ $? -eq 0 ]]
  then
      cat $TERRAFORM_JSON
  fi

  '';



  terranixTrace = writeShellScriptBin "terranix-trace" /* sh */ ''
  FILE=${"$"}{1:-config.nix}

  if [ ! -f $FILE ]
  then
      echo "$FILE does not exist"
      exit 1
  fi

  nix-instantiate --eval \
                  --strict \
                  --json \
                  -I config=$FILE \
                  --show-trace \
                  ${toString ./core/toplevel.nix}
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
