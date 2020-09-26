# the package
# -----------
{ stdenv, ... }:

stdenv.mkDerivation rec {
  pname = "terranix";
  version = "2.3.0";
  src = ./.;

  installPhase = ''
    mkdir -p $out/{bin,core,modules,lib}
    mv bin core modules lib $out/
  '';

  meta = with stdenv.lib; {
    description = "A NixOS like terraform-json generator";
    homepage = "https://github.com/mrVanDalo/terranix";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ mrVanDalo ];
  };

}

