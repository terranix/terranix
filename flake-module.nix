{ inputs, lib, self, flake-parts-lib, ... }: with lib; {
  options = {
    perSystem = flake-parts-lib.mkPerSystemOption
      ({ config, options, pkgs, inputs', system, ... }:
        let
          cfg = config.terranix;
        in
        {
          options.terranix = {

            createDevShells = mkOption {
              description = lib.mdDoc ''
                Whether to create `devShells` or not. By default enabled.
                You can disable this if you want to customize the `devShell` creation youself or otherwise
                wanting to avoid output definition conflicts.

                The devShells are still available at `terranix.terranixConfigurations.result.outputs.devShells`, should
                you want to incorporate them using `pkgs.mkShell.inputsFrom` or similar.
              '';
              type = types.bool;
              default = true;
            };

            terranixConfigurations = mkOption {
              description = lib.mdDoc ''
                A submodule of all terranix configurations.'';
              type = types.attrsOf
                (types.submodule ({ name, ... } @ submod: {
                  options = {
                    terraformWrapper = mkOption {
                      description = lib.mdDoc ''
                        How to invoke terraform for this terranix configuration.

                        Forwarded to lib.mkTerranixTfWrapper.
                      '';
                      default = { };
                      type = types.submodule {
                        options = {
                          extraRuntimeInputs = mkOption {
                            description = lib.mdDoc ''
                              Extra runtimeInputs for the terraform
                              invocations.
                            '';
                            type = types.listOf types.package;
                            default = [ ];
                          };
                          prefixText = mkOption {
                            description = lib.mdDoc ''
                              Prefix text
                            '';
                            type = types.str;
                            default = "";
                          };
                          suffixText = mkOption {
                            description = lib.mdDoc ''
                              Suffix text
                            '';
                            type = types.str;
                            default = "";
                          };
                        };
                      };
                    };

                    modules = mkOption {
                      description = lib.mdDoc ''
                        Modules of the Terranix configuration.
                      '';
                      type = types.listOf types.path;
                      default = [ ];
                    };

                    workdir = mkOption {
                      description = lib.mdDoc ''
                        Working directory of the terranix configuration.
                        Defaults to submodule name.
                      '';
                      type = types.str;
                      default = name;
                    };

                    result = mkOption {
                      description = lib.mdDoc ''
                        A collection of useful read-only outputs by this configuration. 
                        For debugging or otherwise.
                      '';
                      default = { };
                      readOnly = true;
                      type = types.submodule {
                        options = {
                          terraformConfiguration = mkOption {
                            description = lib.mdDoc ''
                              The exposed Terranix configuration as created by lib.terranixConfiguration.
                            '';
                            default = inputs.terranix.lib.terranixConfiguration {
                              inherit system;
                              inherit (submod.config) modules;
                            };
                          };
                          terraformWrapper = mkOption {
                            description = lib.mdDoc ''
                              The exposed, wrapped Terraform.
                            '';
                            default = pkgs.writeShellApplication {
                              name = "terraform";
                              runtimeInputs = [ pkgs.terraform ] ++ submod.config.terraformWrapper.extraRuntimeInputs;
                              text = ''
                                ${submod.config.terraformWrapper.prefixText}
                                terraform "$@"
                                ${submod.config.terraformWrapper.suffixText}
                              '';
                            };
                            type = types.package;
                          };
                          outputs = mkOption {
                            description = lib.mdDoc ''
                              The exposed Terraform outputs as created by lib.mkTerranixOutputs.
                            '';
                            default = inputs.terranix.lib.mkTerranixOutputs {
                              inherit pkgs;
                              inherit (submod.config.result) terraformConfiguration terraformWrapper;
                              prefixText = ''
                                mkdir -p ${submod.config.workdir}
                                cd ${submod.config.workdir}
                              '';

                            };
                          };
                        };
                      };
                    };
                  };
                }));
            };
          };

          config = {
            apps = builtins.mapAttrs
              (name: tnixConfig: {
                program = tnixConfig.result.outputs.scripts.apply.overrideAttrs {
                  inherit name;
                  passthru = tnixConfig.result.outputs.scripts;
                };
              })
              cfg.terranixConfigurations
            // (pkgs.lib.optionalAttrs
              (cfg.terranixConfigurations ? "default")
              (builtins.mapAttrs
                (_: script: { program = script; })
                cfg.terranixConfigurations.default.result.outputs.scripts
              ));

            devShells = mkIf cfg.createDevShells (builtins.mapAttrs
              (_: tnixConfig: tnixConfig.result.outputs.devShells.default)
              cfg.terranixConfigurations);


          };
        });
  };
}

