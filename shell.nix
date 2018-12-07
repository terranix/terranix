{ pkgs ?  import <nixpkgs> {} }:

let

  nixform = pkgs.writeShellScriptBin "nixform" ''
    FILE=${"$"}{1:-config.nix}

    nix-instantiate --eval --strict --json \
      -I config=$FILE \
      ${toString ./core/default.nix}
  '';

in pkgs.mkShell {

  # needed pkgs
  # -----------
  buildInputs = with pkgs; [
    nixform
    terraform
  ];

  # run this on start
  # -----------------
  shellHook = ''

  HISTFILE=${toString ./.}/.history

  '';
}
