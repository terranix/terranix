{lib, pkgs, ...}:
let

  # fetch modules from another repository
  terranix = pkgs.fetchgit {
    url = https://github.com/mrVanDalo/terranix.git;
    rev = "94b6f32618b5ea3cdd3f11bb039fff92a8d64ec3";
    sha256 = "1xhq8hqi4iy3qmn99nf60mks6rhvr0yzwdmqdm72q1rkc9drg4hc";
  };

in
{

  imports = [ "${terranix}/example/modules" ];

  # configure admin ssh keys
  users.admins.palo.publicKey = "${lib.fileContents (toString ~/.ssh/hetzner_example_rsa.pub)}";
  # configure provisioning private Key to be used when running provisioning on the machines
  provisioner.privateKeyFile = toString ~/.ssh/hetzner_example_rsa;

  # install a grafana examples server (from example modules)
  servers.grafana = {
    enable = true;
    plugins = [ "grafana-worldmap-panel" ];
  };

}
