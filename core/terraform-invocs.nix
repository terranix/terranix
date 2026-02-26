{ pkgs ? import <nixpkgs> { }, terraformConfiguration, terraformWrapper ? null, prefixText ? "" }:
let
  wrapper =
    if terraformWrapper == null then {
      package = pkgs.terraform;
      extraRuntimeInputs = [];
      inherit prefixText;
      suffixText = "";
    }
    else if terraformWrapper ? package then {
      inherit (terraformWrapper) package;
      extraRuntimeInputs = terraformWrapper.extraRuntimeInputs or [];
      prefixText = terraformWrapper.prefixText or "";
      suffixText = terraformWrapper.suffixText or "";
    }
    else {
      package = terraformWrapper;
      extraRuntimeInputs = [];
      inherit prefixText;
      suffixText = "";
    };

  tfBinaryName = wrapper.package.meta.mainProgram;

  mkTfScript = name: text: pkgs.writeShellApplication {
    inherit name;
    runtimeInputs = [ wrapper.package ] ++ wrapper.extraRuntimeInputs;
    text = ''
      ${wrapper.prefixText}
      ln -sf ${terraformConfiguration} config.tf.json
      ${tfBinaryName} init
      ${text}
      ${wrapper.suffixText}
    '';
  };
in
rec {
  scripts = {
    apply = mkTfScript "apply" "${tfBinaryName} apply";
    destroy = mkTfScript "destroy" "${tfBinaryName} destroy";
  };

  apps = pkgs.lib.fix (self:
    (builtins.mapAttrs (_: script: { program = script; }) scripts)
    // { default = self.apply; });

  devShells.default = pkgs.mkShell {
    buildInputs = (builtins.attrValues scripts) ++ [ wrapper.package ];
  };
}
