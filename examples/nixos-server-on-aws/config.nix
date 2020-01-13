{ pkgs, config, ... }:
let
  nixosAmis = import (builtins.fetchurl {
    url =
      "https://raw.githubusercontent.com/NixOS/nixpkgs/master/nixos/modules/virtualisation/ec2-amis.nix";
  });

in {

  provider.aws.region = "us-east-1";

  resource.aws_instance.proxy = {
    ami = nixosAmis."19.09"."${config.provider.aws.region}".hvm-ebs;
    instance_type = "t2.micro";

    tags = {
      Name = "Proxy";
      terranix = "true";
      Terraform = "true";
    };
  };

}
