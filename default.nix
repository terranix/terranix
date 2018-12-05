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
      server = {
        nginx = {
          name = "nginx-node";
          image  = "debian-9";
        };
        test = {
          name = "test-node";
          image  = "debian-9";
        };
      };
      volume.test = {
        name = "this-ist-a-test";
        size = 10;
        # todo : this is how I want to call it 
        # server = config.hetzner.server.nginx.name;
        server = "\${hcloud_server.node1.id}";
      };
    };

  }

