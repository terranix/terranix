# FUNCTIONS

Nix comes with a ton of functions that
make your life easier.

A good overview can be found 
[here]( https://storage.googleapis.com/files.tazj.in/nixdoc/manual.html#sec-functions-library).

## optionalAttrs

Useful to create a resource depending on a condition.
The following example adds a bastion host only if
the variable `bastionHostEnable` is set to true.

This is just an example for illustration, but such things
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
## transform lists to Attributesets

`map`
: map a list to another list.

`zipAttrs`
: merge sets of attributes and combine each attribute value into a list.

Useful to create resources out of a small amount
of information by containing a lot of similar data.

The following example shows how to create 3 s3buckets with the same configuration.

```nix
{ lib, ... }:
let
  s3Buckets = [
    "awesome-com"
    "awesome-org"
    "awesome-live"
  ];
in
{
  resource.aws_s3_bucket = lib.zipAttrs (lib.map (name:
    {
      "${name}" = {
        bucket = name;
        acl = "public-read";

        cors_rule = {
          allowed_headers = ["*"];
          allowed_methods = ["PUT" "POST" "GET"];
          allowed_origins = ["https://awesome.com"];
          expose_headers  = ["ETag"];
          max_age_seconds = 3000;
        }
      };
    }
  ) s3Buckets)
}
```
