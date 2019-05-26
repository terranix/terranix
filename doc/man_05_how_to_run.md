
## How to run

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
