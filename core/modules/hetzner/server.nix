{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.hetzner;

in {


  options.hetzner.server = mkOption {
    default = {};

    type = with types; attrsOf (submodule ( {name, ... }: {
      options = {
        "_ref" = mkOption {
          type = with types; string;
          default = "hcloud_server.${name}";
          description = ''
            internal object that should not be overwritten.
            used to generate references
          '';
        };
        name = mkOption {
          type    = with types; string;
          description = ''
            name - (Required, string) Name of the server to create (must be unique per project and a valid hostname as per RFC 1123).
          '';
        };
        server_type = mkOption {
          type    = with types; string;
          description = ''
            server_type - (Required, string) Name of the server type this server should be created with.
          '';
        };
        image = mkOption {
          type    = with types; string;
          description = ''
            image - (Required, string) Name or ID of the image the server is created from.
          '';
        };
        location = mkOption {
          type    = with types; nullOr string;
          default = null;
          description = ''
            location - (Optional, string) The location name to create the server in. nbg1, fsn1 or hel1
          '';
        };
        datacenter = mkOption {
          type    = with types; nullOr string;
          default = null;
          description = ''
            datacenter - (Optional, string) The datacenter name to create the server in.
          '';
        };
        user_data = mkOption {
          type    = with types; nullOr string;
          default = null;
          description = ''
            user_data - (Optional, string) Cloud-Init user data to use during server creation
          '';
        };
        ssh_keys = mkOption {
          type    = with types; listOf string;
          default = [];
          description = ''
            ssh_keys - (Optional, list) SSH key IDs or names which should be injected into the server at creation time
          '';
        };
        keep_disk = mkOption {
          type    = with types; nullOr bool;
          default = null;
          description = ''
            keep_disk - (Optional, bool) If true, do not upgrade the disk. This allows downgrading the server type later.
          '';
        };
        iso = mkOption {
          type    = with types; nullOr string;
          default = null;
          description = ''
            iso - (Optional, string) Name of an ISO image to mount.
          '';
        };
        rescue = mkOption {
          type    = with types; nullOr string;
          default = null;
          description = ''
            rescue - (Optional, string) Enable and boot in to the specified rescue system. This enables simple installation of custom operating systems. linux64 linux32 or freebsd64
          '';
        };
        labels = mkOption {
          type    = with types; attrsOf string;
          default = {};
          description = ''
            labels - (Optional, map) User-defined labels (key-value pairs) should be created with.
          '';
        };
        backups = mkOption {
          type    = with types; nullOr bool;
          default = null;
          description = ''
            backups - (Optional, boolean) Enable or disable backups.
          '';
        };
      };
    }));
 };

  config = mkIf cfg.enable {
    resource.hcloud_server = cfg.server;
  };
}
