
# automatically generated, you should change resource_worker_script.json instead
# documentation : https://www.terraform.io/docs/providers/cloudflare/r/worker_script.html
{ config, lib, ... }:
with lib;
with types;
{
  options.cloudflare.resource.worker_script = mkOption {
    default = {};
    description = "";
    type = with types; attrsOf ( submodule ( { name, ... }: {
      options = {
      # internal object that should not be overwritten.
      # used to generate references
      "_ref" = mkOption {
        type = with types; string;
        default = "cloudflare_worker_script.${name}";
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
      zone = mkOption {
        type = string;
        
        description = "- (Required for single-script accounts) The zone for the script.";
      };
      # automatically generated, change the json file instead
      name = mkOption {
        type = string;
        
        description = "- (Required for multi-script accounts) The name for the script.";
      };
      # automatically generated, change the json file instead
      content = mkOption {
        type = string;
        
        description = "- (Required) The script content.";
      };
    }; }));
  };

  config =
    let
      result = flip mapAttrs
        config.cloudflare.resource.worker_script
          (key: value:
          let
            filteredValues = filterAttrs (key: _: key != "extraConfig") value;
            extraConfig = value.extraConfig;
          in
            filteredValues // extraConfig);
    in
      mkIf ( config.cloudflare.enable && length (builtins.attrNames result) != 0 ) {
        resource.cloudflare_worker_script = result;
      };
}

