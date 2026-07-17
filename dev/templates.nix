{ inputs, ... }:
{
  # nix flake init -t github:terranix/terranix#flake
  flake.templates = inputs.terranix-examples.templates // {
    default = inputs.terranix-examples.defaultTemplate;
  };
}
