{ pkgs ?  import <nixpkgs> {} }:

let

  nixform = pkgs.writeShellScriptBin "nixform" ''
    FILE=${"$"}{1:-config.nix}

    nix-instantiate --eval --strict --json \
      -I config=$FILE \
      ${toString ./core/default.nix}
  '';


  terraform-current = pkgs.terraform.overrideAttrs( old: rec {
    version = "0.11.10";
    name = "terraform-${version}";
    src = pkgs.fetchFromGitHub {
      owner  = "hashicorp";
      repo   = "terraform";
        rev    = "v${version}";
        sha256 = "08mapla89g106bvqr41zfd7l4ki55by6207qlxq9caiha54nx4nb";
      };
    });

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
    ${pkgs.curl}/bin/curl \
      ${input.url} \
      | ${pkgs.pup}/bin/pup \
        "${input.pupArgs} json{}" \
      | jq '.[] | { url :  "${input.url}", type : "${input.type}", "arguments" : [ .children[] | ${input.jqArgs} ]}'
  '';

  parse-markdown-files = files:
    let
      commands = builtins.map parse-markdown-part files;
    in
      pkgs.writeShellScriptBin "generate-coreModules"
        (pkgs.lib.concatStringsSep "\n" commands);



  parser =
  let

    r = "resource";
    d = "data";

    jq_1 = ''{ "\(.children[0].text)": .text }'';
    jq_2 = ''{ "\(.children[0].children[0].text)": .children[0].text }'';
    jq_0 = ''{ "test": "\(.children)" }'';

    pup_1 = "#argument-reference + p + ul";

  in
    parse-markdown-files [

# github
#{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = https://raw.githubusercontent.com/terraform-providers/terraform-provider-github/master/website/docs/r/branch_protection.html.markdown ; }
#{ type = r; pupArgs = pup_1; jqArgs = jq_2; url = https://raw.githubusercontent.com/terraform-providers/terraform-provider-github/master/website/docs/r/issue_label.html.markdown ; }
#{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = https://raw.githubusercontent.com/terraform-providers/terraform-provider-github/master/website/docs/r/membership.html.markdown ; }
#{ type = r; pupArgs = pup_1; jqArgs = jq_2; url = https://raw.githubusercontent.com/terraform-providers/terraform-provider-github/master/website/docs/r/organization_project.html.markdown ; }
#{ type = r; pupArgs = pup_1; jqArgs = jq_2; url = https://raw.githubusercontent.com/terraform-providers/terraform-provider-github/master/website/docs/r/organization_webhook.html.markdown ; }
#{ type = r; pupArgs = pup_1; jqArgs = jq_2; url = https://raw.githubusercontent.com/terraform-providers/terraform-provider-github/master/website/docs/r/project_column.html.markdown ; }
#{ type = r; pupArgs = pup_1; jqArgs = jq_2; url = https://raw.githubusercontent.com/terraform-providers/terraform-provider-github/master/website/docs/r/repository.html.markdown ; }
#{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = https://raw.githubusercontent.com/terraform-providers/terraform-provider-github/master/website/docs/r/repository_collaborator.html.markdown ; }
#{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = https://raw.githubusercontent.com/terraform-providers/terraform-provider-github/master/website/docs/r/repository_deploy_key.html.markdown ; }
#{ type = r; pupArgs = pup_1; jqArgs = jq_2; url = https://raw.githubusercontent.com/terraform-providers/terraform-provider-github/master/website/docs/r/repository_project.html.markdown ; }
#{ type = r; pupArgs = pup_1; jqArgs = jq_2; url = https://raw.githubusercontent.com/terraform-providers/terraform-provider-github/master/website/docs/r/repository_webhook.html.markdown ; }
#{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = https://raw.githubusercontent.com/terraform-providers/terraform-provider-github/master/website/docs/r/team.html.markdown ; }
#{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = https://raw.githubusercontent.com/terraform-providers/terraform-provider-github/master/website/docs/r/team_membership.html.markdown ; }
#{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = https://raw.githubusercontent.com/terraform-providers/terraform-provider-github/master/website/docs/r/team_repository.html.markdown ; }
#{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = https://raw.githubusercontent.com/terraform-providers/terraform-provider-github/master/website/docs/r/user_gpg_key.html.markdown ; }
#{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = https://raw.githubusercontent.com/terraform-providers/terraform-provider-github/master/website/docs/r/user_invitation_accepter.html.markdown ; }
#{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = https://raw.githubusercontent.com/terraform-providers/terraform-provider-github/master/website/docs/r/user_ssh_key.html.markdown ; }

#{ type = d; pupArgs = pup_1; jqArgs = jq_0; url = https://raw.githubusercontent.com/terraform-providers/terraform-provider-github/master/website/docs/d/ip_ranges.html.markdown ;}
#{ type = d; pupArgs = pup_1; jqArgs = jq_0; url = https://raw.githubusercontent.com/terraform-providers/terraform-provider-github/master/website/docs/d/repositories.html.markdown ;}
#{ type = d; pupArgs = pup_1; jqArgs = jq_0; url = https://raw.githubusercontent.com/terraform-providers/terraform-provider-github/master/website/docs/d/repository.html.markdown ;}
#{ type = d; pupArgs = pup_1; jqArgs = jq_0; url = https://raw.githubusercontent.com/terraform-providers/terraform-provider-github/master/website/docs/d/team.html.markdown ;}
#{ type = d; pupArgs = pup_1; jqArgs = jq_0; url = https://raw.githubusercontent.com/terraform-providers/terraform-provider-github/master/website/docs/d/user.html.markdown ;}

{ type = r; pupArgs = pup_1; jqArgs = jq_0; url = https://www.terraform.io/docs/providers/github/r/branch_protection.html ;}

      ];

in pkgs.mkShell {

  # needed pkgs
  # -----------
  buildInputs = with pkgs; [
    nixform
    terraform-current
    pup
    pandoc
    parser
  ];

  # run this on start
  # -----------------
  shellHook = ''

  HISTFILE=${toString ./.}/.history

  '';
}
