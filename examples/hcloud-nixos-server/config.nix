{ lib, pkgs, ...}:
let
  hcloud-modules = pkgs.fetchgit {
    url = "https://github.com/mrVanDalo/terranix-hcloud.git";
    rev = "5fa359a482892cd973dcc6ecfc607f4709f24495";
    sha256 = "0smgmdiklj98y71fmcdjsqjq8l41i66hs8msc7k4m9dpkphqk86p";
  };
in {

  imports = [ "${hcloud-modules}/default.nix" ];

  # configure admin ssh keys
  users.admins.palo.publicKey = "${lib.fileContents ./sshkey.pub}";

  # configure provisioning private Key to be used when running provisioning on the machines
  provisioner.privateKeyFile = toString ./sshkey;

  # install a grafana examples server (from example modules)
  hcloud.nixserver = {
    codimd = {
      enable = true;
      configurationFile = pkgs.writeText "configuration.nix" ''
        { pkgs, lib, config, ... }:
        {

          networking.firewall.allowedUDPPorts = [
            config.services.codimd.configuration.port
          ];
          networking.firewall.allowedTCPPorts = [
            config.services.codimd.configuration.port
          ];

          services.codimd = {
            enable = true;
            configuration = {
              db = {
                dialect = "sqlite";
                storage = "/var/lib/codimd/db.codimd.sqlite";
                useCDN = false;
              };
              port = 8000;
            };
          };

        }
      '';
    };
    gogs = {
      enable = true;
      configurationFile = pkgs.writeText "configuration.nix" ''
        { pkgs, lib, config, ... }:
        {

          networking.firewall.allowedUDPPorts = [
            config.services.gogs.httpPort
          ];
          networking.firewall.allowedTCPPorts = [
            config.services.gogs.httpPort
          ];

          services.gogs = {
            enable = true;
            httpPort = 8000;
          };
        }
      '';
    };
    nginx = {
      enable = true;
      provisioners = [
        {
          file.destination = "/etc/nginx.nix";
          file.content = ''
            { pkgs, lib, config, ... }:
            {

              services.nginx.virtualHosts."git.awesome.com".locations."/".proxyPass =
                "http://''${ hcloud_server.nixserver-gogs.ipv4_address }:8000";

              services.nginx.virtualHosts."codimd.awesome.com".locations."/".proxyPass =
                "http://''${ hcloud_server.nixserver-codimd.ipv4_address }:8000";

            }
          '';
        }
      ];
      configurationFile = pkgs.writeText "configuration.nix" ''
        { pkgs, lib, config, ... }:
        {
          imports = [ /etc/nginx.nix ];

          networking.firewall.allowedUDPPorts = [ 80 ];
          networking.firewall.allowedTCPPorts = [ 80 ];

          services.nginx = {
            enable = true;
          };
        }
      '';
    };
  };

}
