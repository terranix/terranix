# Terranix

A NixOS way to create terraform.json files.

## How to use

create a `config.nix` for example

```sh
{ config , ... }:
{
  hcloud = {
    enable = true;
    resource.server.nginx = {
      name = "my.nginx";
      image  = "debian-9";
      server_type = "cx11";
      backups = false;
    };
  };
}
```

run `terranix config.nix` and it will output json you can pipe in a file `config.tf.json`.
Use the resulting file like you would use a `.tf` file written in `HCL`.

## How to write modules

You can write modules, like you would in NixOS.
Of course you the modules of `man configuration.nix` are not present here.
(see the [NixOS Manual](https://nixos.org/nixos/manual/index.html#sec-writing-modules) for more details)

## How to install

in your NixOS overlays just add

```sh
  terranix = callPackage (super.fetchgit {
    url = "https://github.com/mrVanDalo/terranix.git";
    rev = "1.1.0";
    sha256 = "0zbzlwm1aqq8a8dqf4gx8p11qi2pv1hwpg7i2wh23bc7zb6g513x";
  }) { };
```

## Documentation

just run `man terranix` to get an short overview, and a detailed documentation about all
providers which are currentlyc supported.
