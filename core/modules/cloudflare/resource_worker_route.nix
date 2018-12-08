
# automatically generated, you should change resource_worker_route.json instead
# documentation : https://www.terraform.io/docs/providers/cloudflare/r/worker_route.html
{ config, lib, ... }:
with lib;
with types;
{
  options.cloudflare.resource.worker_route = mkOption {
    default = {};
    description = "";
    type = with types; attrsOf ( submodule {
      options = {
      # internal object that should not be overwritten.
      # used to generate references
      "_ref" = mkOption {
        type = with types; string;
        default = "cloudflare.worker_route";
        description = "";
      };

      # automatically generated, change the json file instead
      zone = mkOption {
        type = nullOr string;
        default = null;
        description = "- (Required) The zone to add the route to.";
      };
      # automatically generated, change the json file instead
      pattern = mkOption {
        type = nullOr string;
        default = null;
        description = "- (Required) The";
      };
      # automatically generated, change the json file instead
      enabled = mkOption {
        type = nullOr string;
        default = null;
        description = "(For single-script accounts only) Whether to run the worker script for requests that match the route pattern. Default is";
      };
      # automatically generated, change the json file instead
      script_name = mkOption {
        type = nullOr string;
        default = null;
        description = "(For multi-script accounts only) Which worker script to run for requests that match the route pattern. If is empty, workers will be skipped for matching requests.";
      };
    }; });
  };

  config = mkIf config.cloudflare.enable {
    resource.cloudflare = config.cloudflare.resource.worker_route;
  };

}

