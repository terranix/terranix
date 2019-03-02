# Terranix

A NixOS way to create `terraform.json` files.

## How to use

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

## How to write modules

You can write modules, like you would in NixOS.
Of course you the modules of `man configuration.nix` are not present here.
(see the [NixOS Manual](https://nixos.org/nixos/manual/index.html#sec-writing-modules) for more details)

### Example

To get an idea on how working with terranix would look like,
have a look at [the example folder](./example/).

### preload

Terranix comes with predefined modules which can be used as
inspiration and to create logic on top.
They live in `./modules`.

### do Assertions

To make an assertion in your module use the `mkAssert` command.
Here is an example

```nix
config = mkAssert (cfg.parameter != "fail" ) "parameter is set to fail!" {
  resource.aws_what_ever."${cfg.parameter}" = {
    I = "love nixos";
  };
};
```

## How to install

Just add

```nix
  terranix = callPackage (super.fetchgit {
    url = "https://github.com/mrVanDalo/terranix.git";
    rev = "2.0.0";
    sha256 = "<sha in here>";
  }) { };
```

to your NixOS overlays or your `shell.nix`.
Please make sure you use the latest release and use the proper sha.

## Documentation

Run `man terranix` to get an overview on how to use it.

## See also

* [nix-instantiate introduction](https://tech.ingolf-wagner.de/nixos/nix-instantiate/)
* [NixOS Manual](https://nixos.org/nixos/manual/index.html#sec-writing-modules)
