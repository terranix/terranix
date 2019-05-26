
## mkAssert

To make an assertion in your module use the `mkAssert` command.
Here is an example

```nix
config = mkAssert (cfg.parameter != "fail") "parameter is set to fail!" {
  resource.aws_what_ever."${cfg.parameter}" = {
    I = "love nixos";
  };
};
```