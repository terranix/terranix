{ pkgs ? import <nixpkgs> { } }:
let

  terranix = pkgs.callPackage ../../default.nix {};

  terraform = pkgs.writers.writeBashBin "terraform" ''
    export TF_VAR_hcloud_api_token=`${pkgs.pass}/bin/pass development/hetzner.com/api-token`
    ${pkgs.terraform_0_12}/bin/terraform "$@"
  '';

in pkgs.mkShell {

  buildInputs = [

    terranix
    terraform

    (pkgs.writers.writeBashBin "example-prepare" ''
      ${pkgs.openssh}/bin/ssh-keygen -P "" -f ${toString ./.}/sshkey
    '')

    (pkgs.writers.writeBashBin "example-run" ''
      set -e
      set -o pipefail
      ${terranix}/bin/terranix | ${pkgs.jq}/bin/jq '.' > config.tf.json
      ${terraform}/bin/terraform init
      ${terraform}/bin/terraform apply
    '')

    (pkgs.writers.writeBashBin "example-cleanup" ''
      ${terraform}/bin/terraform destroy
      rm ${toString ./.}/config.tf.json
      rm ${toString ./.}/sshkey
      rm ${toString ./.}/sshkey.pub
      rm ${toString ./.}/terraform.tfstate*
    '')

  ];
}

