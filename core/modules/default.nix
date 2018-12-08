{ config, lib, ... }:
{ imports = [

./hcloud/resource_floating_ip.nix
./hcloud/data_floating_ip.nix
./hcloud/resource_server.nix
./hcloud/resource_volume.nix
./hcloud/resource_volume_attachment.nix
./hcloud/data_ssh_key.nix
./hcloud/data_image.nix
./hcloud/resource_rdns.nix
./hcloud/data_volume.nix
./hcloud/resource_ssh_key.nix
./hcloud/resource_floating_ip_assignment.nix
./cloudflare/resource_worker_script.nix
./cloudflare/resource_load_balancer.nix
./cloudflare/resource_record.nix
./cloudflare/resource_access_policy.nix
./cloudflare/data_ip_ranges.nix
./cloudflare/resource_worker_route.nix
./cloudflare/resource_zone_lockdown.nix
./cloudflare/resource_page_rule.nix
./cloudflare/resource_access_application.nix
./cloudflare/resource_zone.nix
./cloudflare/resource_waf_rule.nix
./cloudflare/resource_custom_pages.nix
./cloudflare/resource_rate_limit.nix
./cloudflare/resource_access_rule.nix
./cloudflare/resource_load_balancer_pool.nix
./cloudflare/resource_account_member.nix
./cloudflare/resource_firewall_rule.nix
./cloudflare/resource_filter.nix
./cloudflare/resource_load_balancer_monitor.nix
./cloudflare/resource_zone_settings_override.nix

];}
