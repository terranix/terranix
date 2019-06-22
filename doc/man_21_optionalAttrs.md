
## optionalAttrs

Useful to create a resource depending on a condition.
The following example adds a bation host only if
the variable `bastionHostEnable` is set to true.

This is just an example for illustration and such things
are better solved using
[modules](https://nixos.wiki/wiki/NixOS_Modules).

```nix
{ lib, ... }:
let
  bastionHostEnable = true;
in
{
  resource.aws_instance = lib.optionalAttrs bastionHostEnable {
    "bastion" = {
      ami = "ami-969ab1f6"
      instance_type = "t2.micro"
      associate_public_ip_address = true
    };
  };
}
```