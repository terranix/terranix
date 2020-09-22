# Changelog

## [Unreleased]
- add `--pkgs` option to commands to allow overriding/pinning nixpkgs on the command line
- add `pkgs` parameter to `core/default.nix` to allow pinning packages when calling `core/` directly from Nix.

## [2.2.3] - 2020-04-22

- add Release-Checklist.md
- add Changelog.md
- add magic merge tests
- add magicMergeOption for core options. Now all the terraform parameters will be merged magically.
- improve core options documentation
- terrranix-doc: add path and url parameter
- add multi line string documentation
- add escaping expression documentation
- support provider aliasing

## [2.2.2] - 2020-02-23

- add testcases for --with-nulls
- add documentation for --with-nulls
- add command line argument --with-null
- update readme of hcloud-nixos-server-with-plops example

## [2.2.1] - 2020-01-27

- update examples readme
- renamed examples folder
        
## [2.2.0] - 2020-01-27

- add man-pages for terranix-doc commands
- module cleanup and refactoring
- add terraform-doc-man
- add terranix-doc-json
- add ssh key to aws example
- add nixos-server-on-aws example

## [2.1.2] - 2019-10-24

- under GPLv3 license 
- created testcases mkAssert 
