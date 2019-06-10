# for development
{ pkgs ?  import <nixpkgs> {} }:

with pkgs.lib;
with builtins;

let

  terranix = pkgs.callPackages ../default.nix {};

  test = import ./test.nix { inherit pkgs terranix; inherit (pkgs) lib; };

  testFolder = folder:
    let
      ls = builtins.readDir folder;
      files = builtins.attrNames (filterAttrs (file: fileType: fileType == "regular") ls );
      nixFiles = builtins.filter (hasSuffix "nix") files;

      # possible
      script = file: ''
        @test "Testing : ${folder}/${file}" {
          run ${terranix}/bin/terranix --quiet ${folder}/${file}
          [ "$status" -eq 0 ]
          [ "$output" =  ${escapeShellArg (fileContents "${folder}/${file}.output")} ]
        }
      '';

      batsScripts =  map (text: pkgs.writeText "test" text) test;
      allScripts = map (file: "${pkgs.bats}/bin/bats ${file}") batsScripts;
    in
    pkgs.writeScript "script" (concatStringsSep "\n" allScripts);

  testScript =
    let
      testFolders = attrNames (filterAttrs (file: fileType: fileType == "directory") (readDir (toString ./.)));
      fullTestFolders = map (file: "${toString ./.}/${file}") testFolders;
    in
      pkgs.writeShellScriptBin "test-terranix" ''
        set -e
        ${concatStringsSep "\n" (map testFolder fullTestFolders)}
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
