{ pkgs ?  import <nixpkgs> {} }:

let

  nixform = pkgs.writeShellScriptBin "nixform" ''
    FILE=${"$"}{1:-config.nix}

    nix-instantiate --eval --strict --json \
      -I config=$FILE \
      ${toString ./core/default.nix}
  '';


  terraform-current = pkgs.terraform.overrideAttrs( old: rec {
    version = "0.11.10";
    name = "terraform-${version}";
    src = pkgs.fetchFromGitHub {
      owner  = "hashicorp";
      repo   = "terraform";
        rev    = "v${version}";
        sha256 = "08mapla89g106bvqr41zfd7l4ki55by6207qlxq9caiha54nx4nb";
      };
    });

in pkgs.mkShell {

  # needed pkgs
  # -----------
  buildInputs = with pkgs; [
    nixform
    terraform-current
    pup
    pandoc
  ];

  # run this on start
  # -----------------
  shellHook = ''

  HISTFILE=${toString ./.}/.history

  '';
}
