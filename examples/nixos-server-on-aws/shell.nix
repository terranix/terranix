{ pkgs ? import <nixpkgs> { } }:
let

  terranix = pkgs.callPackage (pkgs.fetchgit {
    url = "https://github.com/mrVanDalo/terranix.git";
    rev = "6097722f3a94972a92d810f3a707351cd425a4be";
    sha256 = "1d8w82mvgflmscvq133pz9ynr79cgd5qjggng85byk8axj6fg6jw";
  }) { };

  terraform = pkgs.writers.writeBashBin "terraform" ''
    export AWS_ACCESS_KEY_ID=`${pkgs.pass}/bin/pass development/aws/access_id`
    export AWS_SECRET_ACCESS_KEY=`${pkgs.pass}/bin/pass development/aws/secret_key`
    ${pkgs.terraform_0_12}/bin/terraform "$@"
  '';

in pkgs.mkShell {

  buildInputs = [

    terranix
    terraform

    (pkgs.writers.writeBashBin "run" ''
      set -e
      set -o pipefail
      ${terranix}/bin/terranix | ${pkgs.jq}/bin/jq '.' > config.tf.json
      ${terraform}/bin/terraform init
      ${terraform}/bin/terraform apply
    '')

  ];
}

