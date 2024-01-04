{ inputs, lib, self, flake-parts-lib, ... }: with lib; {
  options = {
    perSystem = flake-parts-lib.mkPerSystemOption
      ({ config, options, pkgs, inputs', system, ... }:
        let
          cfg = config.terranix;
        in
        {
          options.terranix = {

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
                      default = name;
                    };

                    result = mkOption {
                      description = lib.mdDoc ''
                        A collection of useful read-only outputs by this configuration. 
                        For debugging or otherwise.
                      '';
                      default = { };
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
            legacyPackages = builtins.mapAttrs
              (_: tnixConfig: tnixConfig.result.outputs.scripts)
              cfg.terranixConfigurations
            // (pkgs.lib.optionalAttrs
              (cfg.terranixConfigurations ? "default")
              cfg.terranixConfigurations.default.result.outputs.scripts);

            devShells = builtins.mapAttrs
              (_: tnixConfig: tnixConfig.result.outputs.devShells.default)
              cfg.terranixConfigurations;


          };
        });
  };
}

