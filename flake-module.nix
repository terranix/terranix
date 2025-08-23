{ terranix }:
{ inputs, lib, flake-parts-lib, ... }: with lib; {
  options = {
    perSystem = flake-parts-lib.mkPerSystemOption
      ({ config, options, pkgs, inputs', system, ... }:
        let
          cfg = config.terranix;
        in
        {
          imports = [
            (mkRenamedOptionModule [ "terranix" "setDevShell" ] [ "terranix" "exportDevShells" ])
          ];

          options.terranix = {

            exportDevShells = mkOption {
              description = ''
                Whether to export a `devShell` for each terranix configuration.

                If you wish to create the `devShells` yourself, you can disable this option
                and use `pkgs.mkShell.inputsFrom` with `terranix.terranixConfigurations.<name>.result.devShell`.
              '';
              type = types.bool;
              default = true;
            };

            terranixConfigurations = mkOption
              {
                description = "A submodule of all terranix configurations.";
                default = { };
                type = types.attrsOf
                  (types.submodule ({ name, ... } @ submod: {
                    options = {
                      terraformWrapper = {
                        package = mkPackageOption pkgs "terraform" {
                          example = "pkgs.opentofu";
                          extraDescription = ''
                            Specifies which Terraform implementation you want to use.

                            You may also specify which plugins you want to use with your Terraform implementation:

                                pkgs.terraform.withPlugins (p: [ p.external p.local p.null ])

                            or for OpenTofu:

                                pkgs.opentofu.withPlugins (p: [ p.external p.local p.null ])
                          '';
                        };
                        extraRuntimeInputs = mkOption {
                          description = ''
                            Extra runtimeInputs for the terraform
                            invocations.
                          '';
                          type = types.listOf types.package;
                          default = [ ];
                        };
                        prefixText = mkOption {
                          description = ''
                            Extra commands to run in the wrapper before invoking Terraform
                          '';
                          type = types.lines;
                          default = "";
                        };
                        suffixText = mkOption {
                          description = ''
                            Extra commands to run in the wrapper after invoking Terraform
                          '';
                          type = types.lines;
                          default = "";
                        };
                      };

                      modules = mkOption {
                        description = ''
                          Modules of the Terranix configuration.
                        '';
                        type = types.listOf types.deferredModule;
                        default = [ ];
                      };

                      extraArgs = mkOption {
                        description = ''
                          Extra arguments that are accessible from Terranix configuration.
                        '';
                        type = types.attrsOf types.anything;
                        default = { };
                      };

                      workdir = mkOption {
                        description = ''
                          Working directory of the terranix configuration.
                          Defaults to submodule name.
                        '';
                        type = types.str;
                        default = name;
                      };

                      result = mkOption {
                        description = ''
                          A collection of useful read-only outputs by this configuration.
                          For debugging or otherwise.
                        '';
                        default = { };
                        readOnly = true;
                        type = types.submodule {
                          options = {
                            terraformConfiguration = mkOption {
                              description = ''
                                The exposed Terranix configuration as created by lib.terranixConfiguration.
                              '';
                              default = terranix.lib.terranixConfiguration {
                                inherit system;
                                inherit (submod.config) extraArgs modules;
                              };
                              defaultText = "The final Terraform configuration JSON.";
                            };
                            terraformWrapper = mkOption {
                              description = ''
                                The exposed, wrapped Terraform.
                              '';
                              default = pkgs.writeShellApplication {
                                name = submod.config.terraformWrapper.package.meta.mainProgram;
                                runtimeInputs = [ submod.config.terraformWrapper.package ] ++ submod.config.terraformWrapper.extraRuntimeInputs;
                                text = ''
                                  mkdir -p ${submod.config.workdir}
                                  cd ${submod.config.workdir}
                                  ${submod.config.terraformWrapper.prefixText}
                                  ${submod.config.terraformWrapper.package.meta.mainProgram} "$@"
                                  ${submod.config.terraformWrapper.suffixText}
                                '';
                              };
                              defaultText = "The Terraform wrapper.";
                              type = types.package;
                            };
                            scripts = mkOption {
                              description = ''
                                The exposed Terraform scripts (apply, etc).
                              '';
                              default =
                                let
                                  mkTfScript = name: text: pkgs.writeShellApplication {
                                    inherit name;
                                    runtimeInputs = [ submod.config.result.terraformWrapper ];
                                    text = ''
                                      mkdir -p ${submod.config.workdir}
                                      ln -sf ${submod.config.result.terraformConfiguration} ${submod.config.workdir}/config.tf.json
                                      ${text}
                                    '';
                                  };
                                in
                                let
                                  tfBinaryName = submod.config.result.terraformWrapper.meta.mainProgram;
                                in
                                {
                                  init = mkTfScript "init" ''
                                    ${tfBinaryName} init
                                  '';
                                  apply = mkTfScript "apply" ''
                                    ${tfBinaryName} init
                                    ${tfBinaryName} apply
                                  '';
                                  plan = mkTfScript "plan" ''
                                    ${tfBinaryName} init
                                    ${tfBinaryName} plan
                                  '';
                                  destroy = mkTfScript "destroy" ''
                                    ${tfBinaryName} init
                                    ${tfBinaryName} destroy
                                  '';
                                };
                              defaultText = ''
                                {
                                  init = mkTfScript "init" '''
                                    terraform init
                                  ''';
                                  apply = mkTfScript "apply" '''
                                    terraform init
                                    terraform apply
                                  ''';
                                  plan = mkTfScript "plan" '''
                                    terraform init
                                    terraform plan
                                  ''';
                                  destroy = mkTfScript "destroy" '''
                                    terraform init
                                    terraform destroy
                                  ''';
                                }
                              '';
                            };
                            app = mkOption {
                              description = ''
                                The exposed default app. Made from `result.scripts.apply`.

                                Yes, only a single app, and simply running it as `nix run .#foo` would yield
                                a `terraform apply` for the config `foo`.

                                But then how does random terraform invocations like `nix run .#foo.destroy` work?
                                It's actually still using the same app as before - you're still in the `apply`
                                derivation, as strange as it sounds.

                                The magic lies in the use of derivation `passthru` which (simplified) lets you namespace other
                                derivations inside a main derivation. In other words, `nix run .#foo` runs the `apply` derivation named
                                `foo` like normally. `nix run .#foo.destroy` runs the `destroy` script inside of the `apply` derivation.

                                This workaround is required because the flake schema outputs have no concept of nesting derivations like this -
                                i.e. `apps.x86_64-linux.foo` HAS to resolve to a derivation and NOT an attrset.

                                The `legacyPackages` output is an exception to this rule.
                                It was created because `nixpkgs` constantly nest derivations (consider package sets like `python311Packages`),
                                so an escape hatch was needed for flakes who needed to refer to these nested derivations.
                                But having scripts reside in this output made no semantic sense, so this was done instead as a conceptual simplication.
                              '';
                              default = submod.config.result.scripts.apply.overrideAttrs {
                                inherit name;
                                passthru = submod.config.result.scripts // {
                                  config = submod.config.result.terraformConfiguration;
                                  terraform = submod.config.result.terraformWrapper;
                                  terranixConfig = submod.config;
                                };
                              };
                              defaultText = "The default app which defaults to the `apply` script.";
                            };
                            devShell = mkOption {
                              description = ''
                                The exposed devShell.

                                Note that you have to re-enter/ your devShell when your configuration changes!
                                The invocation scripts will still target your old configuration otherwise.

                                For those who want `devShell`-based access like
                                ```sh
                                $ nix develop .#foo
                                $ apply
                                $ destroy

                                ```
                                As opposed to `app`-based access like
                                ```
                                $ nix run .#foo
                                $ nix run .#foo.destroy
                                ```
                              '';
                              default = pkgs.mkShell {
                                buildInputs =
                                  (builtins.attrValues submod.config.result.scripts)
                                  ++ [ submod.config.result.terraformWrapper ];
                              };
                              defaultText = "The final devShell with scripts and terraform wrapper.";
                            };
                          };
                        };
                      };
                    };
                  }));
              };
          };

          config = {
            packages = lib.mapAttrs (_: tnixConfig: tnixConfig.result.app) cfg.terranixConfigurations;
            apps =
              lib.optionalAttrs
                (cfg.terranixConfigurations ? "default")

                (builtins.mapAttrs
                  (_: script: { program = script; })
                  cfg.terranixConfigurations.default.result.scripts
                );
            devShells = mkIf cfg.exportDevShells (builtins.mapAttrs
              (_: tnixConfig: tnixConfig.result.devShell)
              cfg.terranixConfigurations);


          };
        });
  };
}


