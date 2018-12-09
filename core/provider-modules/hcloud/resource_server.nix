
# automatically generated, you should change resource_server.json instead
# documentation : https://www.terraform.io/docs/providers/hcloud/r/server.html
{ config, lib, ... }:
with lib;
with types;
{
  options.hcloud.resource.server = mkOption {
    default = {};
    description = "";
    type = with types; attrsOf ( submodule ( { name, ... }: {
      options = {
      # internal object that should not be overwritten.
      # used to generate references
      "_ref" = mkOption {
        type = with types; string;
        default = "hcloud_server.${name}";
        description = "";
      };

      # automatically generated
      extraConfig = mkOption {
        type = nullOr attrs;
        default = null;
        example = { provider = "aws.route53"; };
        description = "use this option to add options not coverd by this module";
      };

      # automatically generated, change the json file instead
      name = mkOption {
        type = string;
        
        description = "- (Required, string) Name of the server to create (must be unique per project and a valid hostname as per RFC 1123).";
      };
      # automatically generated, change the json file instead
      server_type = mkOption {
        type = string;
        
        description = "- (Required, string) Name of the server type this server should be created with.";
      };
      # automatically generated, change the json file instead
      image = mkOption {
        type = string;
        
        description = "- (Required, string) Name or ID of the image the server is created from.";
      };
      # automatically generated, change the json file instead
      location = mkOption {
        type = nullOr string;
        default = null;
        description = "- (Optional, string) The location name to create the server in. , or";
      };
      # automatically generated, change the json file instead
      datacenter = mkOption {
        type = nullOr string;
        default = null;
        description = "- (Optional, string) The datacenter name to create the server in.";
      };
      # automatically generated, change the json file instead
      user_data = mkOption {
        type = nullOr string;
        default = null;
        description = "- (Optional, string) Cloud-Init user data to use during server creation";
      };
      # automatically generated, change the json file instead
      ssh_keys = mkOption {
        type = nullOr (listOf string);
        default = null;
        description = "- (Optional, list) SSH key IDs or names which should be injected into the server at creation time";
      };
      # automatically generated, change the json file instead
      keep_disk = mkOption {
        type = nullOr bool;
        default = null;
        description = "- (Optional, bool) If true, do not upgrade the disk. This allows downgrading the server type later.";
      };
      # automatically generated, change the json file instead
      iso = mkOption {
        type = nullOr string;
        default = null;
        description = "- (Optional, string) Name of an ISO image to mount.";
      };
      # automatically generated, change the json file instead
      rescue = mkOption {
        type = nullOr string;
        default = null;
        description = "- (Optional, string) Enable and boot in to the specified rescue system. This enables simple installation of custom operating systems. or";
      };
      # automatically generated, change the json file instead
      labels = mkOption {
        type = nullOr (attrsOf string);
        default = null;
        description = "- (Optional, map) User-defined labels (key-value pairs) should be created with.";
      };
      # automatically generated, change the json file instead
      backups = mkOption {
        type = nullOr bool;
        default = null;
        description = "- (Optional, boolean) Enable or disable backups.";
      };
    }; }));
  };

  config =
    let
      result = flip mapAttrs
        config.hcloud.resource.server
          (key: value:
          let
            filteredValues = filterAttrs (key: _: key != "extraConfig") value;
            extraConfig = value.extraConfig;
          in
            filteredValues // extraConfig);
    in
      mkIf ( config.hcloud.enable && length (builtins.attrNames result) != 0 ) {
        resource.hcloud_server = result;
      };
}

