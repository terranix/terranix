{ pkgs ?  import <nixpkgs> {} }:

# nix-shell script to parse provider APIs

let

  # folder where everything takes place
  moduleFolder = toString ./provider-modules;

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
      | tee ${path}/${input.type}_$file_name.json
  '';

  crawler = path: suffix: files:
    let
      commands = builtins.map (crawlerPart path suffix) files;
    in
      pkgs.writeShellScriptBin "crawl-${suffix}" /* sh */ ''
        rm ${path}/*.json
        ${pkgs.lib.concatStringsSep "\n" commands}
      '';

  pup_1 = "#argument-reference + p + ul";
  pup_2 = "#argument-reference + ul";

  r = "resource";
  d = "data";

  jq_1 = ''[ .children[] | { key: "\( .children[0].name )", description: .text , type : "nullOr string", default : "null" } ]'';
  jq_z = ''{ "test": . }'';
  jq_a = jq_z;

  crawlerHcloud =
    crawler "${moduleFolder}/hcloud" "hcloud" [
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

  crawlerCloudflare =
    crawler "${moduleFolder}/cloudflare" "cloudflare" [
# { type = d; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/cloudflare/d/ip_ranges.html" ;}
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

  moduleCreator =
  let
    defaultNix = "${moduleFolder}/default.nix";
    createDefaultNix = /* sh */ ''
cat > ${defaultNix} <<EOF
{ config, lib, ... }:
{ imports = [

EOF
for nix_file in `find ${moduleFolder} -mindepth 2 -maxdepth 2 -type f | grep -e "nix\$"`
do
  echo ./`echo $nix_file | xargs dirname | xargs basename `/`basename $nix_file` >> ${defaultNix}
done
cat >> ${defaultNix} <<EOF

];}
EOF
    '';

    createNixModules = /* sh */ ''
      for file in `find ${moduleFolder} -mindepth 2 -maxdepth 2 -type f | grep -e "json\$"`
      do
      output_file=`dirname $file`/`basename $file .json`.nix
      cat $file | jq --raw-output '. | "
      # automatically generated, you should change \(.type)_\(.name).json instead
      # documentation : \(.url)
      { config, lib, ... }:
      with lib;
      with types;
      {
        options.\(.modul).\(.type).\(.name) = mkOption {
          default = {};
          description = \"\";
          type = with types; attrsOf ( submodule ( { name, ... }: {
            options = {
            # internal object that should not be overwritten.
            # used to generate references
            \"_ref\" = mkOption {
              type = with types; string;
              default = \"\( if .type == "data" then "data." else "" end )\( .modul )_\( .name ).${"$"}{name}\";
              description = \"\";
            };

            # automatically generated
            extraConfig = mkOption {
              type = nullOr attrs;
              default = {};
              example = { provider = \"aws.route53\"; };
              description = \"use this option to add options not coverd by this module\";
            };

      \( .arguments | map(
      "      # automatically generated, change the json file instead
            \( .key ) = mkOption {
              type = \(.type);
              \( if .default != null then "default = \(.default);" else "" end )
              description = \"\( .description )\";
            };"
      ) | join("\n") )
          }; }));
        };

        config =
          let
            result = flip mapAttrs
              config.\(.modul).\(.type).\(.name)
                (key: value:
                let
                  filteredValues = filterAttrs (key: _: key != \"extraConfig\") value;
                  extraConfig = value.extraConfig;
                in
                  filteredValues // extraConfig);
          in
            mkIf ( config.\(.modul).enable && length (builtins.attrNames result) != 0 ) {
              \(.type).\(.modul)_\(.name) = result;
            };
      }
      "' > $output_file
      done
      '';
  in
    pkgs.writeShellScriptBin "render-modules" /* sh */ ''
      ${createNixModules}
      ${createDefaultNix}
    '';

  createManpages =
  let
    markdownFile = toString ./manpage.md;
    manpage = toString ./manpage.man.1;
  in
    pkgs.writeShellScriptBin "render-manpages" /* sh */ ''
      cat > ${markdownFile} <<EOF
      # DESCRIPTION

      These are all supported terraform providers (for now).
      The type might not be correct, this is because parsing the types is
      very difficult at the moment and must be done semi automatic.

      You can always create a resource like this

      \`\`\`
      resource."<provider_module>"."<name>" = {
        key = value;
      };
      \`\`\`

      this is equivalent to HCL syntax for

      \`\`\`
      resource "<provider_module>" "<name>" {
        key = value
      }
      \`\`\`

      # OPTIONS
      EOF
      for file in `find ${moduleFolder} -mindepth 2 -maxdepth 2 -type f | grep -e "json\$"`
      do
        cat $file | jq --raw-output '"
      ## \(.module).\(.type).\(.name)

      Module definition for equivalent HCL commands of

      ```
      \(.type) \"\(.modul)_\(.name)\" \"name\" {}
      ```

      Documentation : \(.url)

      \( . as $main | [ $main.arguments[] |
        "
      ## \( $main.modul ).\( $main.type ).\( $main.name ).\"\\<name\\>\".\( .key )

      *Type*

      \( .type )

      \( if .default != null then "
      *Default*

      \( .default )" else "" end )

      *Description*

      \( .description )

      "] | join ("\n")
      )

      ## \( .modul ).\( .type ).\( .name ).\"\\<name\\>\".extraConfig

      *Type*

      attrs

      *Default*

      {}

      *Example*

      { provider = \"aws.route53_profile\"; }

      *Description*

      Use this option to add parameters the module has not defined, or if you want to force overwrite something that is defined wrong.

      "' >> ${markdownFile}
      done

      cat <( echo "% TerraNix" && \
        echo "% Ingolf Wagner" && \
        echo "% $( date +%Y-%m-%d )" && \
        cat ${markdownFile} ) \
        | ${pkgs.pandoc}/bin/pandoc - -s -t man \
        > ${manpage}
      rm ${markdownFile}
    '';

in pkgs.mkShell {

  # needed pkgs
  # -----------
  buildInputs = with pkgs; [
    pup
    pandoc
    jq
    crawlerHcloud
    crawlerCloudflare
    moduleCreator
    createManpages
  ];

  # run this on start
  # -----------------
  shellHook = ''

  HISTFILE=${toString ./.}/.history

  '';
}
