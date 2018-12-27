# for development

{ pkgs ?  import <nixpkgs> {} }:

let

  terranix = import ../lib.nix { inherit (pkgs) writeShellScriptBin; };

  terraformCurrent = pkgs.terraform.overrideAttrs( old: rec {
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
    terranix.terranix
    terranix.terranixTrace
    #terraformCurrent
    terraform
    pup
    pandoc
  ];

  # run this on start
  # -----------------
  shellHook = ''

  HISTFILE=${toString ./.}/.history

  '';
}
