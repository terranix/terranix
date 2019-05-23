# for development
{ pkgs ?  import <nixpkgs> {} }:

with pkgs.lib;
with builtins;

let

  terranix = import ../lib.nix { inherit (pkgs) writeShellScriptBin pandoc stdenv writeText; };

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

  testFolder = folder:
    let
      ls = builtins.readDir folder;
      files = builtins.attrNames (filterAttrs (file: fileType: fileType == "regular") ls );
      nixFiles = builtins.filter (hasSuffix "nix") files;
      script = file: /* sh */ ''
        echo "Testing : ${folder}/${file}"
        ${terranix.terranix}/bin/terranix --quiet ${folder}/${file} &> "${folder}/.test-output"
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

  # needed pkgs
  # -----------
  buildInputs = with pkgs; [
    terranix.terranix
    (terranix.manpage "3.3.3")
    #terraformCurrent
    terraform
    pup
    pandoc
    testScript
  ];

  # run this on start
  # -----------------
  shellHook = ''
    HISTFILE=${toString ./.}/.history
  '';
}
