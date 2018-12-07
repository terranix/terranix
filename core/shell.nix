{ pkgs ?  import <nixpkgs> {} }:

# nix-shell script to parse provider APIs

let

  # parser for the markdown files
  # { pupArgs ; jqArgs ; url}
  #parse-markdown-part = input: ''
  #  ${pkgs.pandoc}/bin/pandoc \
  #    --read markdown \
  #    --write html \
  #    ${input.url} \
  #    | ${pkgs.pup}/bin/pup \
  #      "${input.pupArgs} json{}" \
  #    | jq '.[] | { url :  "${input.url}", type : "${input.type}", "arguments" : [ .children[] | ${input.jqArgs} ]}'
  #'';
  parse-markdown-part = input: ''
    ${pkgs.curl}/bin/curl --silent \
      ${input.url} \
      | ${pkgs.pup}/bin/pup \
        "${input.pupArgs} json{}" \
      | jq '.[] | { url :  "${input.url}", type : "${input.type}", "arguments" : ${input.jqArgs} }'
  '';

  parse-markdown-files = suffix: files:
    let
      commands = builtins.map parse-markdown-part files;
    in
      pkgs.writeShellScriptBin "api-crawl-${suffix}"
        (pkgs.lib.concatStringsSep "\n" commands);


  pup_1 = "#argument-reference + p + ul";
  pup_2 = "#argument-reference + ul";

  r = "resource";
  d = "data";

  api-crawler-hcloud =
  let

    jq_1 = ''[ .children[] | { "\( .children[0].name )": .text } ]'';
    jq_z = ''{ "test": . }'';
    jq_a = jq_z;

  in
    parse-markdown-files "hcloud" [

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

in pkgs.mkShell {

  # needed pkgs
  # -----------
  buildInputs = with pkgs; [
    pup
    pandoc
    api-crawler-hcloud
  ];

  # run this on start
  # -----------------
  shellHook = ''

  HISTFILE=${toString ./.}/.history

  '';
}
