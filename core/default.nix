# who is calling this and how to make this better?
let

  pkgs = import <nixpkgs> {};
  terraform = import ./terraform-core.nix pkgs;

in terraform.eval
  {
    imports = [ <config> ];
  }

