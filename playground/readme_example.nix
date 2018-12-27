{ config , ... }:
{
  resource.hcloud_server.nginx = {
    name = "my.nginx";
    image  = "debian-9";
    server_type = "cx11";
    backups = false;
  };
}