# for development
{ pkgs ?  import <nixpkgs> {} }:

let


in pkgs.mkShell {

  # needed pkgs
  # -----------
  buildInputs = with pkgs; [
    (callPackage ../default.nix {})
  ];

  # run this on start
  # -----------------
  shellHook = ''

  HISTFILE=${toString ./.}/.release-history

  '';
}
