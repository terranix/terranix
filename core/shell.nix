{ pkgs ?  import <nixpkgs> {} }:

# nix-shell script to parse provider APIs

let

  crawlerPart = path: input: ''
    ${pkgs.curl}/bin/curl --silent \
      ${input.url} \
      | ${pkgs.pup}/bin/pup \
        "${input.pupArgs} json{}" \
      | jq '.[] | { url :  "${input.url}", type : "${input.type}", "arguments" : ${input.jqArgs} }' \
      | jq '.' \
      | tee --append ${path}
  '';

  crawler = path: suffix: files:
    let
      commands = builtins.map (crawlerPart path) files;
    in
      pkgs.writeShellScriptBin "crawl-${suffix}" /* sh */ ''
        echo "" > ${path}
        ${pkgs.lib.concatStringsSep "\n" commands}
      '';


  pup_1 = "#argument-reference + p + ul";
  pup_2 = "#argument-reference + ul";

  r = "resource";
  d = "data";

  crawler-hcloud =
  let

    jq_1 = ''[ .children[] | { "\( .children[0].name )": .text } ]'';
    jq_z = ''{ "test": . }'';
    jq_a = jq_z;

  in
    crawler "${toString ./modules/hcloud/api.json}" "hcloud" [

{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/hcloud/r/server.html" ;}
{ type = r; pupArgs = pup_2; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/hcloud/r/volume.html" ;}
{ type = r; pupArgs = pup_2; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/hcloud/r/volume_attachment.html" ;}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/hcloud/r/ssh_key.html" ;}
{ type = r; pupArgs = pup_2; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/hcloud/r/floating_ip.html" ;}
{ type = r; pupArgs = pup_2; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/hcloud/r/floating_ip_assignment.html" ;}
{ type = r; pupArgs = pup_2; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/hcloud/r/rdns.html" ;}
{ type = d; pupArgs = pup_2; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/hcloud/d/floating_ip.html" ;}
{ type = d; pupArgs = pup_2; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/hcloud/d/image.html" ;}
{ type = d; pupArgs = pup_2; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/hcloud/d/ssh_key.html" ;}
{ type = d; pupArgs = pup_2; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/hcloud/d/volume.html" ;}

      ];

  crawler-cloudflare =
  let

    jq_1 = ''[ .children[] | { "\( .children[0].name )": .text } ]'';
    jq_z = ''{ "test": . }'';
    jq_a = jq_z;

  in
    crawler "${toString ./modules/cloudflare/api.json}" "cloudflare" [

{ type = d; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/cloudflare/d/ip_ranges.html" ;}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/cloudflare/r/access_application.html" ;}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/cloudflare/r/access_policy.html" ;}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/cloudflare/r/access_rule.html" ;}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/cloudflare/r/account_member.html" ;}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/cloudflare/r/custom_pages.html" ;}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/cloudflare/r/filter.html" ;}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/cloudflare/r/firewall_rule.html" ;}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/cloudflare/r/load_balancer.html" ;}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/cloudflare/r/load_balancer_monitor.html" ;}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/cloudflare/r/load_balancer_pool.html" ;}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/cloudflare/r/page_rule.html" ;}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/cloudflare/r/rate_limit.html" ;}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/cloudflare/r/record.html" ;}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/cloudflare/r/waf_rule.html" ;}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/cloudflare/r/worker_route.html" ;}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/cloudflare/r/worker_script.html" ;}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/cloudflare/r/zone.html" ;}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/cloudflare/r/zone_lockdown.html" ;}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/cloudflare/r/zone_settings_override.html" ;}

      ];

in pkgs.mkShell {

  # needed pkgs
  # -----------
  buildInputs = with pkgs; [
    pup
    pandoc
    crawler-hcloud
    crawler-cloudflare
  ];

  # run this on start
  # -----------------
  shellHook = ''

  HISTFILE=${toString ./.}/.history

  '';
}
