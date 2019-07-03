{ lib, ... }:
{
  resource.test = lib.mkAssert (false) "test" {
    key = "value";
  };
}
