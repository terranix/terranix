{ lib, ... }:
{
  resource.test = lib.mkAssert (true) "test" {
    key = "value";
  };
}
