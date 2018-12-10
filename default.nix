{ stdenv, symlinkJoin, writeShellScriptBin, ... }:

let

  libTerranix = (import ./lib.nix) { inherit writeShellScriptBin ; };

  manpages = version: stdenv.mkDerivation rec {

    inherit version;

    name = "terranix-manpage";

    src = ./core;

    installPhase = ''
      mkdir -p $out/share/man/man1
      cp $src/manpage.man.1 $out/share/man/man1/terranix.1
    '';

  };

in

  symlinkJoin rec {
    version = "1.1.3";
    name = "terranix-${version}";
    paths = [
      libTerranix.terranix
      libTerranix.terranixTrace
      (manpages version)
    ];
    meta = with stdenv.lib; {
      description = "A NixOS like terraform-json generator";
      homepage = https://github.com/mrVanDalo/terranix;
      license = licenses.gpl3;
      platforms = platforms.linux;
      maintainers = with maintainers; [ mrVanDalo ];
    };
  }




