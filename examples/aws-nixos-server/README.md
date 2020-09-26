# NixOS on AWS

This setup shows:

* how to include external files
* how to run terranix and terraform

Deploy a 
[nixos machine](https://grafana.com/)
on
[amazon aws](https://aws.amazon.com).

# How to Run

## What you need

* a setup [passwordstore](https://www.passwordstore.org/).
* an [access id](https://aws.amazon.com/premiumsupport/knowledge-center/create-access-key) 
  stored under `development/aws/access_id`
* an [secret key](https://aws.amazon.com/premiumsupport/knowledge-center/create-access-key) 
  stored under `development/aws/secret_key`

## Steps

* `example-prepare`: to create ssh keys.
* `example-run`: to run terranix and terraform.
* `example-cleanup`: to delete server, ssh keys and terraform data. (don't forget that step, or else it gets costly)
