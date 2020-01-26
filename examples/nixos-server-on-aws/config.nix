{ pkgs, config, lib, ... }:
let
  nixosAmis = import (builtins.fetchurl {
    url =
      "https://raw.githubusercontent.com/NixOS/nixpkgs/master/nixos/modules/virtualisation/ec2-amis.nix";
  });

in {

  provider.aws.region = "us-east-1";

  # provide ssh key
  resource.aws_key_pair.deployer = {
    key_name = "deployer-key";
    public_key = lib.fileContents ~/.ssh/id_rsa.pub;
  };

  # create machine
  resource.aws_instance.proxy = {
    ami = nixosAmis."19.09"."${config.provider.aws.region}".hvm-ebs;
    instance_type = "t2.micro";
    key_name = config.resource.aws_key_pair.deployer.key_name;

    tags = {
      Name = "Proxy";
      terranix = "true";
      Terraform = "true";
    };
  };

}
