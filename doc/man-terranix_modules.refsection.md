# MODULES

The real power behind NixOS and terranix
is the module system, which is fundamentally different to the
Terraform Module system.
Detailed information can be obtained at the
[NixOS Wiki](https://wiki.nixos.org/wiki/NixOS_Modules).

## Module Structure

A module always looks like this:

```nix
{ config, lib, pkgs, ... }:
{
  imports = [
    # list of path to other modules.
  ];

  options = {
    # attribute set of option declarations.
  };

  config = {
    # attribute set of option definitions.
  };
}
```

## Example Module

Here is an example module to enable bastion host setups.

```nix
{ config, lib, pkgs, ... }:
{
  options.security.bastion = {
    enable = mkEnableOption "bastion host infrastructure";
    vpcID = mkOption {
      default = "\${ aws_default_vpc.default.id }";
      type = lib.types.str;
      description = "vpc id to which the bastion host should proxy";
    };
  };

  config = mkIf (config.security.bastion.enable) {
    resource.aws_instance."bastion" = {
      ami = "ami-969ab1f6"
      instance_type = "t2.micro"
      associate_public_ip_address = true
    };
    resource.aws_security_group."bastion-sg" = {
      name = "bastion-security-group";
      vpc_id = config.security.bastion.vpcId;
      ingress.protocol = "tcp";
      ingress.from_port = 22;
      ingress.to_port = 22;
      ingress.cidr_blocks = ["0.0.0.0/0"];
    };
    output."bastion_public_ip".value = "\${ aws_instance.bastion.public_ip }";
  };
}
```

Now you can set the following *everywhere*, to enable the bastion host setup.

```nix
{
  security.bastion.enable = true;
}
```
