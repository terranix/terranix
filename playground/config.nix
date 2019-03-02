{lib, ...}:
{

  imports = [ ./modules ];

  users.admins.palo.publicKey = "${lib.fileContents (toString ~/.ssh/hetzner_example_rsa.pub)}";
  provisioner.privateKey = "${lib.fileContents (toString ~/.ssh/hetzner_example_rsa)}";

  servers.grafana.test = {};

}
