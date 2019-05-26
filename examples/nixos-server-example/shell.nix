{ pkgs ?  import <nixpkgs> {} }:

let

  terranix = pkgs.callPackages ../../default.nix {};

in pkgs.mkShell {

  buildInputs = with pkgs; [
    terranix

    # terraform wrapper
    (pkgs.writeShellScriptBin "terraform" ''
      export TF_VAR_hcloud_api_token=`${pkgs.pass}/bin/pass development/hetzner.com/api-token`
      ${pkgs.terraform}/bin/terraform "$@"
    '')
  ];

  shellHook = ''
    HISTFILE=${toString ./.history}
  '';
}
