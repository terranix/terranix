# DESCRIPTION

Terranix is a NixOS way to generate terraform json.
You can create modules like you would in NixOS.

path
: path to the `config.nix`.
If not given it will use the `config.nix` in the current folder.

## Run Examples

To create a JSON file out of a `config.nix` run

```shell
terranix | jq
```

To create a JSON file out of a file `./path/my-config.nix` run

```shell
terranix ./path/my-config.nix | jq
```

To create a JSON file and run terraform

```shell
terranix > config.tf.json && terraform init && terraform apply
```

## Example: wrapper driven by `_meta.package`

Sometimes you want your terranix module to declare which Terraform implementation (and plugins) it expects, and then build a small wrapper around the evaluated result.

Create a `config.nix`:

```nix
{ pkgs, ... }:
{
  _meta.package = pkgs.opentofu.withPlugins (p: [ p.hashicorp_null ]);

  terraform.required_providers.null = {
    source = "hashicorp/null";
    version = ">= 3.0.0";
  };

  resource.null_resource.hello = {
    triggers.message = "hello from terranix";
  };
}
```

Then create a `tofu.nix` wrapper which uses both the evaluated config and evaluated package:

```nix
{ pkgs ? import <nixpkgs> { } }:
let
  terranixEval = import <terranix/core/default.nix> {
    inherit pkgs;
    modules = [ ./config.nix ];
  };

  configTfJson = (pkgs.formats.json { }).generate "config.tf.json" terranixEval.config;
  tofuBin = pkgs.lib.getExe terranixEval._meta.package;
in
pkgs.writeShellApplication {
  name = "tofu";
  text = ''
    ln -sf ${configTfJson} ./config.tf.json
    exec ${tofuBin} "$@"
  '';
}
```

Build and run it (no flakes):

```sh
nix-build tofu.nix -I terranix=/path/to/terranix
./result/bin/tofu init
./result/bin/tofu apply
```

`_meta` is removed before JSON rendering, so it never appears in `config.tf.json`.
