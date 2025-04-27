{
  description = "Dependencies for development purposes";

  inputs = {
    terranix-examples.url = "github:terranix/terranix-examples";

    bats-support = {
      url = "github:bats-core/bats-support";
      flake = false;
    };

    bats-assert = {
      url = "github:bats-core/bats-assert";
      flake = false;
    };
  };

  outputs = _: { };
}
