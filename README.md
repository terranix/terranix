# terranix

terranix is a [Nix][nix]-based infrastructure-as-code tool that combines the providers of
[Terraform][tf] (or [OpenTofu][ot]) and the lazy, functional configuration of [NixOS][nixos].
terranix works as an alternative to HCL by generating [Terraform JSON][tf-json] that can then be
applied using the same providers.

[nix]: https://serokell.io/blog/what-is-nix
[tf]: https://developer.hashicorp.com/terraform
[ot]: https://opentofu.org/
[nixos]: https://nixos.org/
[tf-json]: https://www.terraform.io/docs/configuration/syntax-json.html

# Documentation

See [terranix.org](https://terranix.org/) for [getting started](https://terranix.org/getting-started.html).

## Manpages

* `man terranix`
* `man terranix-modules`
* `man terranix-doc-json`
* `man terranix-doc-man`

# See also

* [nix-instantiate introduction](https://tech.ingolf-wagner.de/nixos/nix-instantiate/)
* [NixOS Manual](https://nixos.org/nixos/manual/index.html#sec-writing-modules)
