# Terranix

A NixOS way to create `terraform.json` files.

### How to install

```nix
  terranix = callPackage (super.fetchgit {
    url = "https://github.com/mrVanDalo/terranix.git";
    rev = "6097722f3a94972a92d810f3a707351cd425a4be";
    sha256 = "1d8w82mvgflmscvq133pz9ynr79cgd5qjggng85byk8axj6fg6jw";
  }) { };
```

### How to use

create a `config.nix` for example

```nix
{ ... }:
{
  resource.hcloud_server.nginx = {
    name = "terranix.nginx";
    image  = "debian-10";
    server_type = "cx11";
    backups = false;
  };
  resource.hcloud_server.test = {
    name = "terranix.test";
    image  = "debian-9";
    server_type = "cx11";
    backups = true;
  };
}
```

run `terranix config.nix` and it will output json you can pipe in a file `config.tf.json`.

### How to write modules

You can write modules, like you would in NixOS.
Of course the modules of `man configuration.nix` are not present here.
See the [NixOS Manual](https://nixos.org/nixos/manual/index.html#sec-writing-modules) for more details,
and have a look at the [examples folder](./examples/) to get an impression how you
could use terranix.

## Documentation

### Manpages

Run `man terranix`.

### Core Argument merging

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

### preload

Terranix comes with predefined modules which can be used as
inspiration and to create logic on top.
They live in
[./modules](./modules/).

## See also

* [nix-instantiate introduction](https://tech.ingolf-wagner.de/nixos/nix-instantiate/)
* [NixOS Manual](https://nixos.org/nixos/manual/index.html#sec-writing-modules)
