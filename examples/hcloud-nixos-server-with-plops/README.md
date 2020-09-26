# NixOS Server Example with plops

This setup shows:

* how to use a terranix module
* how to use 3rd party provision software after terraform.
* how to run terranix and terraform

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

# How to Run

## What you need

* a setup [passwordstore](https://www.passwordstore.org/).
* a [hcloud token](https://docs.hetzner.cloud/#overview-getting-started) 
  stored under `development/hetzner.com/api-token`

## Steps

* `example-prepare`: to create ssh keys.
* `example-run`: to run terranix and terraform.
* go in `./plops` and `nix-shell --run "deploy-nixserver-server1"`, to provision machine.
* `example-cleanup`: to delete server, ssh keys and terraform data. (don't forget that step, or else it gets costly)

