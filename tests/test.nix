{ nixpkgs, pkgs, lib, terranix, ... }:
with lib;
let
  # example:
  #[ {
  #  text = "assert : don't trigger error on true mkAssert ";
  #  file = ./terranix-tests/05.nix;
  #  success = true;
  #  outputFile = ./terranix-tests/05.nix.output;
  #} ]
  terranix-tests = import ./terranix-tests.nix;
  terranix-test-template = { text, file, options ? [ ], success ? true, outputFile ? "", partialMatchOutput ? false, ... }:
    ''
      @test "${text}" {
      run ${terranix}/bin/terranix ${concatStringsSep " " options} --pkgs ${nixpkgs} --quiet ${file}
      ${if success then "assert_success" else "assert_failure"}
      ${optionalString (outputFile != "") "assert_output ${optionalString partialMatchOutput "--partial"} ${escapeShellArg (fileContents outputFile)}"}
      }
    '';


  terranix-doc-json-tests = import ./terranix-doc-json-tests.nix;
  terranix-doc-json-test-template = { text, path ? "", file, options ? [ ], success ? true, outputFile ? "", ... }:
    ''
      @test "${text}" {
      run ${terranix}/bin/terranix-doc-json --quiet ${optionalString (path != "") "--path ${path}"} ${concatStringsSep " " options} --pkgs ${nixpkgs} --quiet ${file}
      ${if success then "assert_success" else "assert_failure"}
      ${optionalString (outputFile != "") "assert_output ${escapeShellArg (fileContents outputFile)}"}
      }
    '';


in
(map terranix-test-template terranix-tests) ++
(map terranix-doc-json-test-template terranix-doc-json-tests)
