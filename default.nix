{ stdenv, lib, jq, nix, makeWrapper }:

stdenv.mkDerivation {
  pname = "terranix";
  version = "2.9.0";

  src = ./.;

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p $out/{bin,core,modules,lib,providers}
    mv bin core modules lib providers share $out/

    wrapProgram $out/bin/terranix-doc-json \
      --prefix PATH : ${lib.makeBinPath [ jq nix ]}
  '';
}
