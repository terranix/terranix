{ lib, ... }:

{
  resource.foo.bar = {
    a-reference = lib.tfRef "data.another-resource.id";
  };
}
