
# automatically generated, you should change resource_worker_script.json instead
# documentation : https://www.terraform.io/docs/providers/cloudflare/r/worker_script.html
{ config, lib, ... }:
with lib;
with types;
{
  options.cloudflare.resource.worker_script = mkOption {
    default = {};
    description = "";
    type = with types; attrsOf ( submodule {
      options = {
      # internal object that should not be overwritten.
      # used to generate references
      "_ref" = mkOption {
        type = with types; string;
        default = "cloudflare.worker_script";
        description = "";
      };

      # automatically generated, change the json file instead
      zone = mkOption {
        type = nullOr string;
        default = null;
        description = "- (Required for single-script accounts) The zone for the script.";
      };
      # automatically generated, change the json file instead
      name = mkOption {
        type = nullOr string;
        default = null;
        description = "- (Required for multi-script accounts) The name for the script.";
      };
      # automatically generated, change the json file instead
      content = mkOption {
        type = nullOr string;
        default = null;
        description = "- (Required) The script content.";
      };
    }; });
  };

  config = mkIf config.cloudflare.enable {
    resource.cloudflare = config.cloudflare.resource.worker_script;
  };

}

