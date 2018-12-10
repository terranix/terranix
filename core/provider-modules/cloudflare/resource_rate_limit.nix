
# automatically generated, you should change resource_rate_limit.json instead
# documentation : https://www.terraform.io/docs/providers/cloudflare/r/rate_limit.html
{ config, lib, ... }:
with lib;
with types;
{
  options.cloudflare.resource.rate_limit = mkOption {
    default = {};
    description = "";
    type = with types; attrsOf ( submodule ( { name, ... }: {
      options = {
      # internal object that should not be overwritten.
      # used to generate references
      "_ref" = mkOption {
        type = with types; string;
        default = "cloudflare_rate_limit.${name}";
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
      zone = mkOption {
        type = string;
        
        description = "- (Required) The DNS zone to apply rate limiting to.";
      };
      # automatically generated, change the json file instead
      threshold = mkOption {
        type = either string int;
        
        description = "- (Required) The threshold that triggers the rate limit mitigations, combine with period. i.e. threshold per period (min: 2, max: 1,000,000).";
      };
      # automatically generated, change the json file instead
      period = mkOption {
        type = either string int;
        
        description = "- (Required) The time in seconds to count matching traffic. If the count exceeds threshold within this period the action will be performed (min: 1, max: 86,400).";
      };
      # automatically generated, change the json file instead
      action = mkOption {
        type = attrs;
        
        description = "- (Required) The action to be performed when the threshold of matched traffic within the period defined is exceeded.";
      };
      # automatically generated, change the json file instead
      match = mkOption {
        type = nullOr attrs;
        default = null;
        description = "- (Optional) Determines which traffic the rate limit counts towards the threshold. By default matches all traffic in the zone. See definition below.";
      };
      # automatically generated, change the json file instead
      disabled = mkOption {
        type = nullOr bool;
        default = null;
        description = "- (Optional) Whether this ratelimit is currently disabled. Default: .";
      };
      # automatically generated, change the json file instead
      description = mkOption {
        type = nullOr string;
        default = null;
        description = "- (Optional) A note that you can use to describe the reason for a rate limit. This value is sanitized and all tags are removed.";
      };
      # automatically generated, change the json file instead
      bypass_url_patterns = mkOption {
        type = nullOr (listOf string);
        default = null;
        description = "- (Optional) URLs matching the patterns specified here will be excluded from rate limiting.";
      };
      # automatically generated, change the json file instead
      correlate = mkOption {
        type = nullOr attrs;
        default = null;
        description = "- (Optional) Determines how rate limiting is applied. By default if not specified, rate limiting applies to the clients IP address.";
      };
    }; }));
  };

  config =
    let
      result = flip mapAttrs
        config.cloudflare.resource.rate_limit
          (key: value:
          let
            filteredValues = filterAttrs (key: _: key != "extraConfig") value;
            extraConfig = value.extraConfig;
          in
            filteredValues // extraConfig);
    in
      mkIf ( config.cloudflare.enable && length (builtins.attrNames result) != 0 ) {
        resource.cloudflare_rate_limit = result;
      };
}

