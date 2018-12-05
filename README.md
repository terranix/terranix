# nix-instatiate tests

## How to edit

for now edit the `default.nix`.
You can create modules like you would in NixOS.
But at the end only the values `provider`, `variable` and `resource` will be rendered.

## How to run

call a `nix-shell` and inside you can do :

```sh
nixform
```

or

```sh
nixform config.nix
```