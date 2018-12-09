# Terranix

A NixOS way to create terraform.json files.

## How to use

create a `config.nix` for example

```
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

## Documentation

just run `man terranix` to get an short overview, and a detailed documentation about all
providers which are currentlyc supported.

