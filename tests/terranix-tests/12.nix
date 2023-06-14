{ lib, ... }:

{
  resource.foo.bar = {
    a-reference = lib.tfRef "data.another-resource.id";
    b-reference = lib.tf.ref "data.another-resource.id";
  };
}
