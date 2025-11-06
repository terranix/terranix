# Changelog

## [Unreleased]

- Deprecate `terranixConfigurationAst`
- Expose `config` from `terranixConfiguration`
- Fix docs generation (#134)
- flake-parts: Separate `apps` from `packages` output (#133)
- feat: ephemeral block (#129)
- flake-parts: Fix documentation eval (#128)
- flake-module: rename `setDevShell` to `exportDevShells` for clarity (#126)
- flake-module: fix `devShells` failing to build (#125)
- flake-module: fix wrapper for `opentofu` called `terraform` (#127)
- Expose configuration directly from `flake-parts` module (#124)
- refactor: Use flake-parts partitions to reduce inputs (#120)
- fix: Ensure workspace exists in flake-parts module scripts (#119)
- chore: Avoid evaluating terraform package for option docs (#121)
- doc: Become maintainer (remove "unmaintained" message) (#122)
- feat: Support opentofu in flake-parts module (a57e554)
- feat: Improve flake-parts module (52e7d56)
- flake-module: allow customizing `extraArgs` (15e8c4f)
- fix: add float to sanitize (4176bcf)
- .github: stop using Git Flow (7aa6c13)
- flake: lock `flake-parts` (64bdac5)
- flake-module: fix module not being exported as a file module (cd36914)
- flake-module: add `defaultText` for all options with complex defaults (1310a45)
- flake-module: remove `lib.mdDoc` (e9c827d)

## [2.8.0] 2024-10-15

- add import option
- add flake part module, providing apps: init, apply and destroy

## [2.7.0] 2023-09-22

- add templatefile() helper
- add lib.tf
- add referencable functor

## [2.6.0] 2023-05-24

- Add `tfRef` function to create terraform references.
- refactor tests
- pin nixpkgs due to different nixpkgs versions
- make nix flake check not complain anymore
- improve error message for types

## [2.5.5] - 2022-09-06

- resources with empty body are filtered now.

## [2.5.4] - 2022-07-11

- follow new flake defaults https://nixos.org/manual/nix/stable/release-notes/rl-2.7.html
- use of github actions for automated testing

## [2.5.3] - 2022-01-07

- re-adding man pages for terranix, terranix-modules, terranix-doc-json and terranix-doc-man.

## [2.5.2] - 2021-11-17

- add terranixConfigurationAst
- add terranixOptionAst

## [2.5.1] - 2021-11-13

- pretty formated json output

## [2.5.0] - 2021-11-07

- add terranixConfiguration replacement for buildTerranix
- add terranixOptions replacement for buildOptions
- fix [#18](https://github.com/terranix/terranix/issues/18): empty sets will not be converted to `null` anymore.

## [2.4.0] - 2021-10-10

- add flake support `buildTerranix`
- add flake support `buildOptions`
- extract examples to [terranix-examples](https://github.com/terranix/terranix-examples)

## [2.3.0] - 2020-09-26

- use bash scripts instead of lib.nix, to put terranix in nixpgks
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
