
# automatically generated, you should change resource_load_balancer.json instead
# documentation : https://www.terraform.io/docs/providers/cloudflare/r/load_balancer.html
{ config, lib, ... }:
with lib;
with types;
{
  options.cloudflare.resource.load_balancer = mkOption {
    default = {};
    description = "";
    type = with types; attrsOf ( submodule ( { name, ... }: {
      options = {
      # internal object that should not be overwritten.
      # used to generate references
      "_ref" = mkOption {
        type = with types; string;
        default = "cloudflare_load_balancer.${name}";
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
        type = nullOr string;
        default = null;
        description = "- (Required) The zone to add the load balancer to.";
      };
      # automatically generated, change the json file instead
      name = mkOption {
        type = nullOr string;
        default = null;
        description = "- (Required) The DNS name to associate with the load balancer.";
      };
      # automatically generated, change the json file instead
      fallback_pool_id = mkOption {
        type = nullOr string;
        default = null;
        description = "- (Required) The pool ID to use when all other pools are detected as unhealthy.";
      };
      # automatically generated, change the json file instead
      default_pool_ids = mkOption {
        type = nullOr string;
        default = null;
        description = "- (Required) A list of pool IDs ordered by their failover priority. Used whenever region/pop pools are not defined.";
      };
      # automatically generated, change the json file instead
      description = mkOption {
        type = nullOr string;
        default = null;
        description = "- (Optional) Free text description.";
      };
      # automatically generated, change the json file instead
      ttl = mkOption {
        type = nullOr string;
        default = null;
        description = "- (Optional) Time to live (TTL) of this load balancer&#39;s DNS . Conflicts with - this cannot be set for proxied load balancers. Default is .";
      };
      # automatically generated, change the json file instead
      steering_policy = mkOption {
        type = nullOr string;
        default = null;
        description = "- (Optional) Determine which method the load balancer uses to determine the fastest route to your origin. Valid values  are: &#34;off&#34;, &#34;geo&#34;, &#34;dynamic_latency&#34; or &#34;&#34;. Default is &#34;&#34;.";
      };
      # automatically generated, change the json file instead
      proxied = mkOption {
        type = nullOr string;
        default = null;
        description = "- (Optional) Whether the hostname gets Cloudflare&#39;s origin protection. Defaults to .";
      };
      # automatically generated, change the json file instead
      region_pools = mkOption {
        type = nullOr string;
        default = null;
        description = "- (Optional) A set containing mappings of region/country codes to a list of pool IDs (ordered by their failover priority) for the given region. Fields documented below.";
      };
      # automatically generated, change the json file instead
      pop_pools = mkOption {
        type = nullOr string;
        default = null;
        description = "- (Optional) A set containing mappings of Cloudflare Point-of-Presence (PoP) identifiers to a list of pool IDs (ordered by their failover priority) for the PoP (datacenter). This feature is only available to enterprise customers. Fields documented below.";
      };
      # automatically generated, change the json file instead
      session_affinity = mkOption {
        type = nullOr string;
        default = null;
        description = "- (Optional) Associates all requests coming from an end-user with a single origin. Cloudflare will set a cookie on the initial response to the client, such that consequent requests with the cookie in the request will go to the same origin, so long as it is available.";
      };
    }; }));
  };

  config =
    let
      result = flip mapAttrs
        config.cloudflare.resource.load_balancer
          (key: value:
          let
            filteredValues = filterAttrs (key: _: key != "extraConfig") value;
            extraConfig = value.extraConfig;
          in
            filteredValues // extraConfig);
    in
      mkIf ( config.cloudflare.enable && length (builtins.attrNames result) != 0 ) {
        resource.cloudflare_load_balancer = result;
      };
}

