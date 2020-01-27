{ config, pkgs, lib, ... }:
{

  # setup gogs
  services.gogs = {
    enable = true;
    httpPort = 3000;
  };

  # open port for nginx
  networking.firewall.allowedTCPPorts = [ 80 ];

  # configure nginx to proxy to localhost
  services.nginx = {
    enable = true;
    virtualHosts."git.awesome.com" = {
      default = true;
      locations."/".proxyPass = "http://localhost:${toString config.services.gogs.httpPort}";
    };
  };

}
