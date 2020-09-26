# Simple Server Example

This setup shows:

* how to use a terranix module
* how to write a terranix module
* how to run terranix and terraform

Deploy
[grafana server](https://grafana.com/)
on
[hcloud](https://www.hetzner.com/cloud).
Provisioning just installs
[docker](https://www.docker.com/)
and starts the
[grafana docker container](https://grafana.com/docs/installation/docker/).

# How to Run

## What you need

* a setup [passwordstore](https://www.passwordstore.org/).
* a [hcloud token](https://docs.hetzner.cloud/#overview-getting-started) 
  stored under `development/hetzner.com/api-token`

## Steps

* `example-prepare`: to create ssh keys.
* `example-run`: to run terranix and terraform.
* `example-cleanup`: to delete server, ssh keys and terraform data. (don't forget that step, or else it gets costly)
