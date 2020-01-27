let

  # import plops with pkgs and lib
  opsImport = import ((import <nixpkgs> {}).fetchgit {
    url = "https://github.com/mrVanDalo/plops.git";
    rev = "9fabba016a3553ae6e13d5d17d279c4de2eb00ad";
    sha256 = "193pajq1gcd9jyd12nii06q1sf49xdhbjbfqk3lcq83s0miqfs63";
  });

  ops = let
    overlay = self: super:
    {
      # overwrite ssh to use the generated ssh configuration
      openssh = super.writeShellScriptBin "ssh" ''
        ${super.openssh}/bin/ssh -F ${toString ./generated/ssh-configuration} "$@"
      '';
    };
  in
  opsImport { overlays = [ overlay ]; };

  lib = ops.lib;
  pkgs = ops.pkgs;

  # define all sources
  source = {

    # nixpkgs (no need for channels anymore)
    nixPkgs.nixpkgs.git = {
      ref = "nixos-19.03";
      url = https://github.com/NixOS/nixpkgs-channels;
    };

    # system configurations
    system = name: {
      configs.file = toString ./configs;
      nixos-config.symlink = "configs/${name}/configuration.nix";
    };

    # secrets which are hold and stored by pass
    secrets = name: {
      secrets.pass = {
        dir  = toString ./secrets;
        name = name;
      };
    };
  };

  servers = import ./generated/nixos-machines.nix;

  deployServer = name: {user ? "root", host, ... }:
  with ops;
  jobs "deploy-${name}" "${user}@${host.ipv4}" [
    # deploy secrets to /run/plops-secrets/secrets
    # (populateTmpfs (source.secrets name))
    # deploy system to /var/src/system
    (populate (source.system name))
    # deploy nixpkgs to /var/src/nixpkgs
    (populate source.nixPkgs)
    switch
  ];

in
pkgs.mkShell {

  buildInputs = lib.mapAttrsToList deployServer servers;

  shellHook = ''
    export PASSWORD_STORE_DIR=./secrets
  '';

}
