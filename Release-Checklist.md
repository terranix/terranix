# Release Checklist

* check if tests are green
* run `nix run ".#docs"`
* check if examples still work
* bump version number in default.nix
* update Changelog

## After release

* update nixos/nixpkgs
* update terranix.org getting started commit and checksum
* nix-shell-mix
