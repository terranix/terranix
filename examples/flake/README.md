# nix flake example

This example shows how you could use terranix as flake.
The function lib.buildTerranix delivers a nix package which contains
a `config.tf.json` file, which is compiled from the `terranix_config` argument.

Because terraform needs to run in a folder that is writeable
we use a flake app which copy this `config.tf.json` to the current folder
and runs terraform commands.

* `nix run ".#apply"` run `terraform apply`
* `nix run ".#destroy"` run `terraform destroy`
* `nix run` run `nix run ".#apply"`
