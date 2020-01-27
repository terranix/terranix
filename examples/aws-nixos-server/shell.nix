{ pkgs ? import <nixpkgs> { } }:
let

  terranix = pkgs.callPackage ../../default.nix {};

  terraform = pkgs.writers.writeBashBin "terraform" ''
    export AWS_ACCESS_KEY_ID=`${pkgs.pass}/bin/pass development/aws/access_id`
    export AWS_SECRET_ACCESS_KEY=`${pkgs.pass}/bin/pass development/aws/secret_key`
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

