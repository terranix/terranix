{ inputs, lib, flake-parts-lib, ... }: with lib; {
  options = {
    perSystem = flake-parts-lib.mkPerSystemOption
      ({ config, options, pkgs, inputs', system, ... }:
        let
          cfg = config.terranix;
        in
        {
          options.terranix = {

            setDevShell = mkOption {
              description = ''
                Whether to set default `devShell` or not. By default enabled.
                You can disable this if you want to customize the `devShell` creation youself or otherwise
                wanting to avoid output definition conflicts.

                The devShell are still available at `terranix.terranixConfigurations.<name>.result.devShell`, should
                you want to incorporate them using `pkgs.mkShell.inputsFrom` or similar.
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
                      terraformWrapper = mkOption {
                        description = ''
                          How to invoke terraform for this terranix configuration.
                        '';
                        default = { };
                        type = types.submodule ({ options, ... }: {
                          options = {
                            package = mkPackageOption pkgs "terraform" { };
                            mainProgram = mkOption {
                              type = types.str;
                              default = submod.config.terraformWrapper.package.meta.mainProgram or "terraform";
                              defaultText = lib.literalMD ''
                                `meta.mainProgram` of `${options.package}`, or `"terraform"` if that's missing.
                              '';
                              description = "The main program of the terraform package.";
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
                                Prefix text
                              '';
                              type = types.lines;
                              default = "";
                            };
                            suffixText = mkOption {
                              description = ''
                                Suffix text
                              '';
                              type = types.lines;
                              default = "";
                            };
                          };
                        });
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
                              default = inputs.terranix.lib.terranixConfiguration {
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
                                name = "terraform";
                                runtimeInputs = [ submod.config.terraformWrapper.package ] ++ submod.config.terraformWrapper.extraRuntimeInputs;
                                text = ''
                                  mkdir -p ${submod.config.workdir}
                                  cd ${submod.config.workdir}
                                  ${submod.config.terraformWrapper.prefixText}
                                  ${submod.config.terraformWrapper.mainProgram} "$@"
                                  ${submod.config.terraformWrapper.suffixText}
                                '';
                              };
                              defaultText = "The Terraform wrapper.";
                              type = types.package;
                            };
                            scripts = mkOption {
                              description = ''
                                The exposed Terraform scripts (apply, etc). `result.terraformWrapper` included for convenience.
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
                                {
                                  init = mkTfScript "init" ''
                                    terraform init
                                  '';
                                  apply = mkTfScript "apply" ''
                                    terraform init
                                    terraform apply
                                  '';
                                  plan = mkTfScript "plan" ''
                                    terraform init
                                    terraform plan
                                  '';
                                  destroy = mkTfScript "destroy" ''
                                    terraform init
                                    terraform destroy
                                  '';
                                  terraform = submod.config.result.terraformWrapper;
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
                                  terraform = submod.config.result.terraformWrapper;
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
                                passthru = submod.config.result.scripts;
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
            packages = (lib.mapAttrs (_: tnixConfig: tnixConfig.result.app) cfg.terranixConfigurations) // (
              lib.optionalAttrs
                (cfg.terranixConfigurations ? "default")

                (builtins.mapAttrs
                  (_: script: { program = script; })
                  cfg.terranixConfigurations.default.result.scripts
                )
            );

            devShells = mkIf cfg.setDevShell (builtins.mapAttrs
              (_: tnixConfig: tnixConfig.result.devShell)
              cfg.terranixConfigurations);


          };
        });
  };
}


