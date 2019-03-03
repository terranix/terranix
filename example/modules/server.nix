{ config, lib, pkgs, ... }:
with lib;
let

  cfg = config.hcloud.server;

  allAdmins =
    if ( hasAttr "admins" config.users )
    then
      config.users.admins
    else
      {};

in {

  options.hcloud.server = mkOption {
    default = {};
    type = with types; attrsOf (submodule ({ name, ... }: {
      options = {
        enable = mkEnableOption "server";
        name = mkOption {
          default = "${name}";
          type = with types; str;
          description = ''
            name
          '';
        };
        sshProvision = mkOption {
          default = [];
          type = with types; listOf str;
          description = ''
            list of commands fired on the server when first start
          '';
        };
        image = mkOption {
          default = "ubuntu-18.04";
          type = with types; str;
          description = ''
            image to spawn on the server
          '';
        };
        serverType = mkOption {
          default = "cx11";
          type = with types; str;
          description = ''
            server type (different costs)
          '';
        };
        backups = mkOption {
          default = false;
          type = with types; bool;
          description = ''
            enable backups or not
          '';
        };
      };
    }));
  };

  config =
    mkIf (cfg != {} ) {

      hcloud.enable = true;

      resource.hcloud_server =
        let
          allUsers = mapAttrsToList ( name: ignore: "\${ hcloud_ssh_key.server_${name}.id }" ) allAdmins;

          allResources = mapAttrs' ( name: configuration: {
            name = "${configuration.name}";
            value = {
              name = configuration.name;
              image  = configuration.image;
              server_type = configuration.serverType;
              backups = configuration.backups;
              ssh_keys = allUsers;
              provisioner."remote-exec" = {
                inline = configuration.sshProvision;
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
          ipv4Address = mapAttrs' ( ignore: configuration: { 
            name = "${configuration.name}_ipv4_address";
            value = { value = "\${ hcloud_server.${configuration.name}.ipv4_address }"; } ;
          } ) cfg;

          ipv6Address = mapAttrs' ( ignore: configuration: { 
            name = "${configuration.name}_ipv6_address";
            value = { value = "\${ hcloud_server.${configuration.name}.ipv6_address }"; } ;
          } ) cfg;

        in
          ipv4Address // ipv6Address;
          
      resource.hcloud_ssh_key = 
        let
          allResources = mapAttrs' ( name: configuration: {
            name = "server_${name}";
            value = {
              name = "SSH Key ${name}";
              public_key = configuration.publicKey;
            };
          }) allAdmins;
        in
          allResources;
        
      };
}
