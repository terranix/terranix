
# automatically generated, you should change resource_load_balancer_pool.json instead
# documentation : https://www.terraform.io/docs/providers/cloudflare/r/load_balancer_pool.html
{ config, lib, ... }:
with lib;
with types;
{
  options.cloudflare.resource.load_balancer_pool = mkOption {
    default = {};
    description = "";
    type = with types; attrsOf ( submodule ( { name, ... }: {
      options = {
      # internal object that should not be overwritten.
      # used to generate references
      "_ref" = mkOption {
        type = with types; string;
        default = "cloudflare_load_balancer_pool.${name}";
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
        
        description = "- (Required) A short name (tag) for the pool. Only alphanumeric characters, hyphens, and underscores are allowed.";
      };
      # automatically generated, change the json file instead
      origins = mkOption {
        type = listOf string;
        
        description = "- (Required) The list of origins within this pool. Traffic directed at this pool is balanced across all currently healthy origins, provided the pool itself is healthy. It&#39;s a complex value. See description below.";
      };
      # automatically generated, change the json file instead
      check_regions = mkOption {
        type = nullOr (listOf string);
        default = null;
        description = "- (Optional) A list of regions (specified by region code) from which to run health checks. Empty means every Cloudflare data center (the default), but requires an Enterprise plan. Region codes can be found .";
      };
      # automatically generated, change the json file instead
      description = mkOption {
        type = nullOr string;
        default = null;
        description = "- (Optional) Free text description.";
      };
      # automatically generated, change the json file instead
      enabled = mkOption {
        type = nullOr bool;
        default = null;
        description = "- (Optional) Whether to enable (the default) this pool. Disabled pools will not receive traffic and are excluded from health checks. Disabling a pool will cause any load balancers using it to failover to the next pool (if any).";
      };
      # automatically generated, change the json file instead
      minimum_origins = mkOption {
        type = nullOr int;
        default = null;
        description = "- (Optional) The minimum number of origins that must be healthy for this pool to serve traffic. If the number of healthy origins falls below this number, the pool will be marked unhealthy and we will failover to the next available pool. Default: 1.";
      };
      # automatically generated, change the json file instead
      monitor = mkOption {
        type = nullOr string;
        default = null;
        description = "- (Optional) The ID of the Monitor to use for health checking origins within this pool.";
      };
      # automatically generated, change the json file instead
      notification_email = mkOption {
        type = nullOr string;
        default = null;
        description = "- (Optional) The email address to send health status notifications to. This can be an individual mailbox or a mailing list.";
      };
    }; }));
  };

  config =
    let
      result = flip mapAttrs
        config.cloudflare.resource.load_balancer_pool
          (key: value:
          let
            filteredValues = filterAttrs (key: _: key != "extraConfig") value;
            extraConfig = value.extraConfig;
          in
            filteredValues // extraConfig);
    in
      mkIf ( config.cloudflare.enable && length (builtins.attrNames result) != 0 ) {
        resource.cloudflare_load_balancer_pool = result;
      };
}

