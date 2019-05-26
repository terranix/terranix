{ pkgs, lib, ... }:
{
  imports = [
    ./server.nix
    ./nixserver.nix
  ];
}
