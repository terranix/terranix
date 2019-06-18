# terranix NixOS Server Example with plops

Setup containing opinionated modules to deploy
[NixOS servers](https://nixos.org/)
on
[hcloud](https://www.hetzner.com/cloud)
using
[nixos-infect](https://github.com/elitak/nixos-infect)
with my
[plops](https://github.com/mrVanDalo/plops)
provisioning tool for NixOS,
which is an overlay on krops.

Provisioning uploads the
nixos-infect
script and applys it.
Once the machine is a NixOS machine
you run plops to apply your real setup.

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
