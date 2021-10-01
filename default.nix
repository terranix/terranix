{ stdenv, lib, ... }:

stdenv.mkDerivation rec {
  pname = "terranix";
  version = "2.3.0";
  src = ./.;

  installPhase = ''
    mkdir -p $out/{bin,core,modules,lib}
    mv bin core modules lib $out/
  '';

  meta = with lib; {
    description = "A NixOS like terraform-json generator";
    homepage = "https://github.com/mrVanDalo/terranix";
    license = licenses.gpl3;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ mrVanDalo ];
  };

}

