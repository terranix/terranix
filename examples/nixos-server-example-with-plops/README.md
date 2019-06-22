# NixOS Server Example with plops

Setup containing opinionated modules to deploy
[NixOS servers](https://nixos.org/)
on
[hcloud](https://www.hetzner.com/cloud)
using
[nixos-infect](https://github.com/elitak/nixos-infect)
with my
[plops](https://github.com/mrVanDalo/plops)
provisioning tool for NixOS,
which is an overlay on 
[krops](https://cgit.krebsco.de/krops/about/).

After server creation,
the initial provisioning uploads the
nixos-infect
script and applys it.
After server creation and initialization
terranix/terraform generates
files used for the "real" provisioning
done by plops.

Of course instead of plops you can use every provsioning tool you like
here (e.g. NixOps, Ansible, ... )

## How to Run

Make sure your passwordstore [is setup correctly](#password).


### Server creation

```shell
nix-shell --run "terranix > config.tf.json && terraform init && terraform apply"
```

### Server provisioning

This will recompile git, because we overwrite openssh,
to use the local ssh key.

```shell
cd plops
nix-shell --run "deploy-server1"
```

### Server deletion

```shell
nix-shell --run "terraform destroy"
```

### Password

Passwords are managed by
[pass the password-store](https://www.passwordstore.org/).

You need a
[hcloud token](https://docs.hetzner.cloud/#overview-getting-started)
which is stored under
`development/hetzner.com/api-token`
in your passwordstore.
(Of course you can change that by adjusting the `./shell.nix`).
