
## transform lists to Attributesets

`map`
: map a list to another list.

`zipAttrs`
: Merge sets of attributes and combine each attribute value in to a list.

Useful to create resources out of a small amount
of information with containing a lot of similar data.

The following Example shows how to create 3 s3buckets with the same configuration.

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