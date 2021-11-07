{ stdenv, lib, jq, nix, ... }:

stdenv.mkDerivation {
  pname = "terranix";
  version = "2.5.0";
  src = ./.;


  installPhase = ''
    mkdir -p $out/{bin,core,modules,lib}
    mv bin core modules lib $out/

    mv $out/bin/terranix-doc-json $out/bin/.wrapper_terranix-doc-json

    # manual wrapper because makeWrapper expectes executables
    wrapper=$out/bin/terranix-doc-json
    cat <<EOF>$wrapper
    #!/usr/bin/env bash
    export PATH=$PATH:${jq}/bin:${nix}/bin
    $out/bin/.wrapper_terranix-doc-json "\$@"
    EOF
    chmod +x $wrapper
  '';

  meta = with lib; {
    description = "A NixOS like terraform-json generator";
    homepage = "https://github.com/mrVanDalo/terranix";
    license = licenses.gpl3;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ mrVanDalo ];
  };

}

