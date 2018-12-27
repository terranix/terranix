# the package
# -----------
{ stdenv, symlinkJoin, writeShellScriptBin, 
  pandoc, ... }:

let
  libTerranix = (import ./lib.nix) { inherit writeShellScriptBin stdenv pandoc; };
in

  symlinkJoin rec {
    version = "2.0.0";
    name = "terranix-${version}";
    paths = [
      libTerranix.terranix
      libTerranix.terranixTrace
      (libTerranix.manpages version)
    ];
    meta = with stdenv.lib; {
      description = "A NixOS like terraform-json generator";
      homepage = https://github.com/mrVanDalo/terranix;
      license = licenses.gpl3;
      platforms = platforms.linux;
      maintainers = with maintainers; [ mrVanDalo ];
    };
  }




