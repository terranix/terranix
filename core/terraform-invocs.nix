{ pkgs ? import <nixpkgs> { }, terraformConfiguration, terraform ? pkgs.terraform, ... }:
let
  mkTfScript = name: text: pkgs.writeShellApplication {
    inherit name;
    runtimeInputs = [ terraform ];
    text = ''
      ln -sf ${terraformConfiguration} config.tf.json
      terraform init
      ${text}
    '';
  };
in
rec {
  scripts = {
    apply = mkTfScript "apply" "terraform apply";
    destroy = mkTfScript "destroy" "terraform destroy";
  };

  apps = pkgs.lib.fix (self:
    (builtins.mapAttrs (_: script: { program = script; }) scripts)
    // { default = self.apply; });

  devShells.default = pkgs.mkShell {
    buildInputs = builtins.attrValues scripts;
  };
}


