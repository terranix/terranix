# for development
{ pkgs ?  import <nixpkgs> {} }:

with pkgs.lib;
with builtins;

let

  terranix = pkgs.callPackages ../default.nix {};

  createTest = testimport:
  let
    test = import testimport  { inherit pkgs terranix; inherit (pkgs) lib; };
    batsScripts =  map (text: pkgs.writeText "test" text) test;
    allScripts = map (file: "${pkgs.bats}/bin/bats ${file}") batsScripts;
  in
  pkgs.writeScript "test-script" (concatStringsSep "\n" allScripts);

  testScript =
    let
      allTests = [ (createTest ./test.nix) ];
    in
      pkgs.writeShellScriptBin "test-terranix" ''
        set -e
        ${concatStringsSep "\n" allTests}
      '';

in pkgs.mkShell {

  buildInputs = with pkgs; [
    terranix
    terraform
    pup
    pandoc
    testScript

    bats
  ];

  shellHook = ''
    HISTFILE=${toString ./.}/.history
  '';
}
