let

  pkgs = import <nixpkgs> {};
  terraform = import ./terraform-core.nix pkgs;

in terraform.eval
  {

    imports = [ 
      ./modules/hetzner
      ];

    hetzner = {
      enable = true;
      # provider.token = "hallo";
    };

  }

