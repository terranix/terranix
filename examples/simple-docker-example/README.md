# terranix NixOS Server Example

Setup containing opinionated modules to deploy
[grafana server](https://grafana.com/)
on
[hcloud](https://www.hetzner.com/cloud).
Provisioning just installes [docker](https://www.docker.com/)
and starts
the
[grafana docker container](https://grafana.com/docs/installation/docker/).

## How to Run

to see the JSON output :

```shell
nix-shell --run terranix
```

to roll out this setup:

```shell
nix-shell --run "terranix > config.tf.json && terraform init && terraform apply"
```

Make sure your passwordstore [is setup correctly](#password).

### Password

Passwords are managed by
[pass the password-store](https://www.passwordstore.org/).

You need a
[hcloud token](https://docs.hetzner.cloud/#overview-getting-started)
which is stored under
`development/hetzner.com/api-token`
in your passwordstore.
(Of course you can change that by adjusting the `./shell.nix`).
