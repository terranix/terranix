{ pkgs ?  import <nixpkgs> {} }:

# nix-shell script to parse provider APIs

let


  crawlerPart = path: modul: input: /* sh */ ''
    URL="${input.url}"
    file_name_html=${"$"}{URL##https://*/}
    file_name=`basename $file_name_html .html`
    ${pkgs.curl}/bin/curl --silent \
      ${input.url} \
      | ${pkgs.pup}/bin/pup \
        "${input.pupArgs} json{}" \
      | jq '.[] | {
modul: "${modul}", name: "'$file_name'", url : "${input.url}",
type : "${input.type}", "arguments" : ${input.jqArgs} }' \
      | jq '.' \
      | tee ${path}/$file_name.json
  '';

  crawler = path: suffix: files:
    let
      commands = builtins.map (crawlerPart path suffix) files;
    in
      pkgs.writeShellScriptBin "crawl-${suffix}" /* sh */ ''
        echo "" > ${path}
        ${pkgs.lib.concatStringsSep "\n" commands}
      '';

  pup_1 = "#argument-reference + p + ul";
  pup_2 = "#argument-reference + ul";

  r = "resource";
  d = "data";

  jq_1 = ''[ .children[] | { key: "\( .children[0].name )", description: .text , type : "nullOr string", default : null } ]'';
  jq_z = ''{ "test": . }'';
  jq_a = jq_z;

  crawler-hcloud =
    crawler "${toString ./modules/hcloud}" "hcloud" [
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
    crawler "${toString ./modules/cloudflare}" "cloudflare" [
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

# todo sanitize the descriptions

  moduleCreator = pkgs.writeShellScriptBin "render-moduls" /* sh */ ''
for file in `find ${toString ./.}/modules -mindepth 2 -maxdepth 2 -type f | grep -e "json\$"`
do
cat $file | jq --raw-output '. | "
# automatically generated, you should change the json file instead
# changing this file
{ config, lib, ... }:
with lib;
with types;
{ options.\(.modul).\(.name) = mkOption {
   default = {};
   description = \"\";
   type = with types; attrsOf ( submodule ({ name, ... }: {

     # internal object that should not be overwritten.
     # used to generate references
     \"_ref\" = mkOption {
       type = with types; string;
       default = \"\( .modul ).\( .name )\";
       description = \"\";
     };

\( .arguments | map(
"     \( .key ) = mkOption {
        type = \(.type);
        default = \( .default );
        description = \"\( .description )\";
      };"
) | join("\n") )
   }));
   }
 }
"'
done
'';

in pkgs.mkShell {

  # needed pkgs
  # -----------
  buildInputs = with pkgs; [
    pup
    pandoc
    crawler-hcloud
    crawler-cloudflare
    moduleCreator
  ];

  # run this on start
  # -----------------
  shellHook = ''

  HISTFILE=${toString ./.}/.history

  '';
}
