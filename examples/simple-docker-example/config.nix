{lib, pkgs, ...}:
{

  imports = [ ./modules ];

  # configure admin ssh keys
  users.admins.lass.publicKey = "${lib.fileContents (toString ./sshkey.pub)}";
  # configure provisioning private Key to be used when running provisioning on the machines
  provisioner.privateKeyFile = toString ./sshkey;

  # install a grafana examples server (from example modules)
  servers.grafana = {
    enable = true;
    plugins = [ "grafana-worldmap-panel" ];
  };

}
