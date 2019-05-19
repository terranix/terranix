{lib, ...}:
{

  # import example modules (very opinionated)
  imports = [ ./modules ];

  # configure admin ssh keys
  users.admins.palo.publicKey = "${lib.fileContents (toString ~/.ssh/hetzner_example_rsa.pub)}";
  # configure provisioning private Key to be used when running provisioning on the machines
  provisioner.privateKeyFile = toString ~/.ssh/hetzner_example_rsa;

  # install a grafana examples server (from example modules)
  servers.grafana = {
    enable = true;
    plugins = [ "jdbranham-diagram-panel" "grafana-worldmap-panel" ];
  };

}
