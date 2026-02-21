{ pkgs, ... }:
{
  _meta = {
    fn = x: x;
    pkg = pkgs.hello;
  };

  terraform.required_version = ">= 1.0";
}
