{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.servers.grafana;

  allAdmins = 
    if ( hasAttr "admins" config.users ) 
    then
      config.users.admins
    else
      {};

in {

  options.servers.grafana = mkOption {
    default = {};
    type = with types; attrsOf (submodule ({ name, ... }: {
      options = {
        name = mkOption {
          default = "grafana-${name}";
          type = with types; str;
          description = ''
            name
          '';
        };
      };
    }));
  };

  config =
    mkIf (cfg != {} ) (
      mkMerge [
        { resource.hcloud_server =
            let
              allUsers = mapAttrsToList ( name: ignore: "\${ hcloud_ssh_key.grafana_${name}.id }" ) allAdmins;

              allResources = mapAttrs' ( name: configuration: {
                name = "grafana_${name}";
                value = {
                  name = configuration.name;
                  image  = "ubuntu-18.04";
                  server_type = "cx11";
                  ssh_keys = allUsers;
                  backups = false;
                  provisioner."remote-exec" = {
                    inline = [ 
                        "apt -y install docker.io"
                        ''/usr/bin/docker run -d --name=grafana \
                            -p 80:3000 \
                            grafana/grafana
                        ''
                    ];
                    connection = {
                      type = "ssh";
                      user = "root";
                      private_key = config.provisioner.privateKey ;
                    };
                  };
                };
              }) cfg;
            in
              allResources;

          output = 
            let
              ipv4Address = mapAttrs' ( name: ignore: { 
                name = "grafana_${name}_ipv4_address";
                value = { value = "\${ hcloud_server.grafana_${name}.ipv4_address }"; } ;
              } ) cfg;

              ipv6Address = mapAttrs' ( name: ignore: { 
                name = "grafana_${name}_ipv6_address";
                value = { value = "\${ hcloud_server.grafana_${name}.ipv6_address }"; };
              } ) cfg;
            in
              ipv4Address;
            
              
        }
        {
          resource.hcloud_ssh_key = 
          let
              allResources = mapAttrs' ( name: configuration: {
                name = "grafana_${name}";
                value = {
                  name = "Grafana SSH Key ${name}";
                  public_key = configuration.publicKey;
                };
              }) allAdmins;
            in
              allResources;
        }
        { hcloud.enable = true; }
      ]
    );
}
