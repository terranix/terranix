{ pkgs ?  import <nixpkgs> {} }:

let

  terranix = pkgs.callPackages ../default.nix {};

in pkgs.mkShell {

  buildInputs = with pkgs; [
    terranix
    terraform
  ];

  shellHook = ''
    HISTFILE=${toString ./.history}
  '';
}
