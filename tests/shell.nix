# for development
{ pkgs ?  import <nixpkgs> {} }:

with pkgs.lib;
with builtins;

let

  terranix = pkgs.callPackages ../default.nix {};

  testFolder = folder:
    let
      ls = builtins.readDir folder;
      files = builtins.attrNames (filterAttrs (file: fileType: fileType == "regular") ls );
      nixFiles = builtins.filter (hasSuffix "nix") files;
      script = file: /* sh */ ''
        echo "Testing : ${folder}/${file}"
        ${terranix}/bin/terranix --quiet ${folder}/${file} &> "${folder}/.test-output"
        diff -su "${folder}/.test-output" ${folder}/`basename ${file} .nix`.output
        if [ $? -ne 0 ]
        then
          exit 1
        fi
      '';
    in
      pkgs.writeScript "script" (concatStringsSep "\n" (map script nixFiles));

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
  ];

  shellHook = ''
    HISTFILE=${toString ./.}/.history
  '';
}
