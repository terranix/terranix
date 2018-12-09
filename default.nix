{ stdenv, symlinkJoin, writeShellScriptBin, ... }:

let

  libTerranix = (import ./lib.nix) { inherit writeShellScriptBin ; };

in

  symlinkJoin rec {
    version = "1.0.0";
    name = "terranix-${version}";
    paths = [
      libTerranix.terranix
      libTerranix.terranixTrace
    ];
  }




