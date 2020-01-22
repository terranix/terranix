# terranix library
# ----------------
# in here are all the code that is terranix

{ stdenv, writeShellScriptBin, writeText, pandoc, ... }:
let
  usage = writeText "useage" ''
    Usage: terranix [-q|--quiet] [--trace|--show-trace] [path]
           terranix --help

      -q | --quiet   dont print anything except the json

      -h | --help    print help

      --trace        show trace information if there is an error
      --show-trace

      path           path to the config.nix

    '';
in {

  terranix = writeShellScriptBin "terranix" /* sh */ ''

  set -eu -o pipefail

  QUIET=""
  TRACE=""
  FILE="./config.nix"

  while [[ $# -gt 0 ]]
  do
      case $1 in
          --help| -h)
              cat ${usage}
              exit 0
              ;;
          --quiet | -q)
              QUIET="--quiet"
              shift
              ;;
          --show-trace | --trace)
              TRACE="--show-trace"
              shift
              ;;
          *)
              FILE=$1
              shift
              break
              ;;
      esac
  done

  if [[ ! -f $FILE ]]
  then
      echo "$FILE does not exist"
      exit 1
  fi

  TERRAFORM_JSON=$( nix-build \
      --no-out-link \
      --attr run \
      $QUIET \
      $TRACE \
      -I config=$FILE \
      --expr "
    with import <nixpkgs> {};
    let
      terranix_data = import ${toString ./core/default.nix} { terranix_config = { imports = [ <config> ]; }; };
      terraform_json = builtins.toJSON (terranix_data.config);
    in { run = pkgs.writeText \"config.tf.json\" terraform_json; }
  " )

  NIX_BUILD_EXIT_CODE=$?
  if [[ $NIX_BUILD_EXIT_CODE -eq 0 ]]
  then
      cat $TERRAFORM_JSON
  else
      exit 1
  fi
  exit $NIX_BUILD_EXIT_CODE
  '';

  terranixDocMan = writeShellScriptBin "terranix-doc-man" ''
    set -eu -o pipefail

    FILE="./config.nix"
    OFFLINE=""
    QUIET=""
    TRACE=""

    while [[ $# -gt 0 ]]
    do
        case $1 in
            --help| -h)
                cat ${usage}
                exit 0
                ;;
            --quiet | -q)
                QUIET="--quiet"
                shift
                ;;
            --offline)
                OFFLINE="--option substitute false"
                shift
                ;;
            --show-trace | --trace)
                TRACE="--show-trace"
                shift
                ;;
            *)
                FILE=$1
                shift
                break
                ;;
        esac
    done

    if [[ ! -f $FILE ]]
    then
        echo "$FILE does not exist"
        exit 1
    fi

    TERRAFORM_JSON=$( nix-build \
        --no-out-link \
        $QUIET \
        $OFFLINE \
        $TRACE \
        -I config=$FILE \
        --expr "with import <nixpkgs> {}; callPackage ${toString ./bin/terranix-doc-man.nix} { pkgs = pkgs; }"
    )

    NIX_BUILD_EXIT_CODE=$?
    if [[ $NIX_BUILD_EXIT_CODE -eq 0 ]]
    then
        man $TERRAFORM_JSON/share/man/man5/terranix-doc-man.5
    else
        exit 1
    fi
    exit $NIX_BUILD_EXIT_CODE
  '';

  terranixDocJson = writeShellScriptBin "terranix-doc-json" ''
    set -eu -o pipefail

    FILE="./config.nix"
    OFFLINE=""
    QUIET=""
    TRACE=""

    while [[ $# -gt 0 ]]
    do
        case $1 in
            --help| -h)
                cat ${usage}
                exit 0
                ;;
            --quiet | -q)
                QUIET="--quiet"
                shift
                ;;
            --offline)
                OFFLINE="--option substitute false"
                shift
                ;;
            --show-trace | --trace)
                TRACE="--show-trace"
                shift
                ;;
            *)
                FILE=$1
                shift
                break
                ;;
        esac
    done

    if [[ ! -f $FILE ]]
    then
        echo "$FILE does not exist"
        exit 1
    fi
    TERRAFORM_JSON=$( nix-build \
        --no-out-link \
        $QUIET \
        $OFFLINE \
        $TRACE \
        -I config=$FILE \
        --expr "with import <nixpkgs> {}; callPackage ${toString ./bin/terranix-doc-json.nix} { pkgs = pkgs; }"
    )

    NIX_BUILD_EXIT_CODE=$?
    if [[ $NIX_BUILD_EXIT_CODE -eq 0 ]]
    then
        cat $TERRAFORM_JSON/options.json
    else
        exit 1
    fi
    exit $NIX_BUILD_EXIT_CODE
  '';

}
