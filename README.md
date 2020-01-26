
A NixOS way to create `terraform.json` files.

# Documentation

See [terranix.org](https://terranix.org) for documentation.

## Manpages

* `man terranix`
* `man terranix-modules`
* `man terranix-doc-json`
* `man terranix-doc-man`

## Core Argument merging

The core Arguments are not merged,
because they need to typed define upfront,
which is a condition for merging.

The following options will not be merged :

* `data`
* `locals`
* `module`
* `output`
* `provider`
* `resource`
* `terraform`
* `variable`

More information about this topic can be found in
[the NixOS Manual](https://nixos.org/nixos/manual/index.html#sec-option-types)
and the
[source](./core/terraform-options.nix).

## preload

Terranix comes with predefined modules which can be used as
inspiration and to create logic on top.
They live in
[./modules](./modules/).

# See also

* [nix-instantiate introduction](https://tech.ingolf-wagner.de/nixos/nix-instantiate/)
* [NixOS Manual](https://nixos.org/nixos/manual/index.html#sec-writing-modules)
