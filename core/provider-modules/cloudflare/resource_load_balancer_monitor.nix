
# automatically generated, you should change resource_load_balancer_monitor.json instead
# documentation : https://www.terraform.io/docs/providers/cloudflare/r/load_balancer_monitor.html
{ config, lib, ... }:
with lib;
with types;
{
  options.cloudflare.resource.load_balancer_monitor = mkOption {
    default = {};
    description = "";
    type = with types; attrsOf ( submodule ( { name, ... }: {
      options = {
      # internal object that should not be overwritten.
      # used to generate references
      "_ref" = mkOption {
        type = with types; string;
        default = "cloudflare_load_balancer_monitor.${name}";
        description = "";
      };

      # automatically generated
      extraConfig = mkOption {
        type = nullOr attrs;
        default = {};
        example = { provider = "aws.route53"; };
        description = "use this option to add options not coverd by this module";
      };

      # automatically generated, change the json file instead
      expected_body = mkOption {
        type = string;
        
        description = "- (Required) A case-insensitive sub-string to look for in the response body. If this string is not found, the origin will be marked as unhealthy.";
      };
      # automatically generated, change the json file instead
      expected_codes = mkOption {
        type = either string int;
        
        description = "- (Required) The expected HTTP response code or code range of the health check. Eg";
      };
      # automatically generated, change the json file instead
      method = mkOption {
        type = nullOr string;
        default = null;
        description = "- (Optional) The HTTP method to use for the health check. Default: &#34;GET&#34;.";
      };
      # automatically generated, change the json file instead
      timeout = mkOption {
        type = nullOr (either string int);
        default = null;
        description = "- (Optional) The timeout (in seconds) before marking the health check as failed. Default: 5.";
      };
      # automatically generated, change the json file instead
      path = mkOption {
        type = nullOr string;
        default = null;
        description = "- (Optional) The endpoint path to health check against. Default: &#34;/&#34;.";
      };
      # automatically generated, change the json file instead
      interval = mkOption {
        type = nullOr (either string int);
        default = null;
        description = "- (Optional) The interval between each health check. Shorter intervals may improve failover time, but will increase load on the origins as we check from multiple locations. Default: 60.";
      };
      # automatically generated, change the json file instead
      retries = mkOption {
        type = nullOr (either string int);
        default = null;
        description = "- (Optional) The number of retries to attempt in case of a timeout before marking the origin as unhealthy. Retries are attempted immediately. Default: 2.";
      };
      # automatically generated, change the json file instead
      header = mkOption {
        type = nullOr attrs;
        default = null;
        description = "- (Optional) The HTTP request headers to send in the health check. It is recommended you set a Host header by default. The User-Agent header cannot be overridden. Fields documented below.";
      };
      # automatically generated, change the json file instead
      type = mkOption {
        type = nullOr enum [ "http" "https" ];
        default = null;
        description = "- (Optional) The protocol to use for the healthcheck. Currently supported protocols are &#39;HTTP&#39; and &#39;HTTPS&#39;. Default: &#34;http&#34;.";
      };
      # automatically generated, change the json file instead
      description = mkOption {
        type = nullOr string;
        default = null;
        description = "- (Optional) Free text description.";
      };
    }; }));
  };

  config =
    let
      result = flip mapAttrs
        config.cloudflare.resource.load_balancer_monitor
          (key: value:
          let
            filteredValues = filterAttrs (key: _: key != "extraConfig") value;
            extraConfig = value.extraConfig;
          in
            filteredValues // extraConfig);
    in
      mkIf ( config.cloudflare.enable && length (builtins.attrNames result) != 0 ) {
        resource.cloudflare_load_balancer_monitor = result;
      };
}

