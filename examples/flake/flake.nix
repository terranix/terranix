{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
    terranix = {
      url = "github:mrVanDalo/terranix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, flake-utils, terranix }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        terraform = pkgs.terraform_0_15;
        terraformConfiguration = terranix.lib.buildTerranix {
          inherit pkgs;
          terranix_config = {
            # import a config.nix and maybe other terranix flakes
            imports = [ ./config.nix ];
            # and or inline your terranix code
            resource.local_file.test = {
              filename = "test.txt";
              content = "A terranix created test file. YEY!";
            };
          };
        };
      in {
        defaultPackage = terraformConfiguration;
        # nix run ".#apply"
        apps.apply = {
          type = "app";
          program = toString (pkgs.writers.writeBash "apply" ''
            if [[ -e config.tf.json ]]; then rm -f config.tf.json; fi
            cp ${terraformConfiguration}/config.tf.json config.tf.json \
              && ${terraform}/bin/terraform init \
              && ${terraform}/bin/terraform apply
          '');
        };
        # nix run ".#destroy"
        apps.destroy = {
          type = "app";
          program = toString (pkgs.writers.writeBash "destroy" ''
            if [[ -e config.tf.json ]]; then rm -f config.tf.json; fi
            cp ${terraformConfiguration}/config.tf.json config.tf.json \
              && ${terraform}/bin/terraform init \
              && ${terraform}/bin/terraform destroy
          '');
        };
        # nix run
        defaultApp = self.apps.${system}.apply;
      });
}
