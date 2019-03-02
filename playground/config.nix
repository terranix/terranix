{...}:
{

  users.admins.palo.publicKey = "ssh-rsa asdfasdf ";

  #hcloud.enable = true;

  #resource.hcloud_server.nginx = {
  #  name = "terranix.nginx";
  #  image  = "debian-10";
  #  server_type = "cx11";
  #  backups = false;
  #};

  imports = [ ./modules ];

  servers.grafana.test = {};

}
