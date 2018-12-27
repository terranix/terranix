let 
  pkgs = import <nixpkgs> {}; 
in 

with pkgs;
with pkgs.lib;
with builtins;

let

  # sanitize the resulting configuration
  # removes unwanted parts of the evalModule output
  sanitize = configuration: lib.getAttr (typeOf configuration) {
        bool = configuration;
        int = configuration;
        string = configuration;
        list = map sanitize configuration;
        set =
          let
            stripped = lib.flip lib.filterAttrs configuration
                  (name: value:
                    name != "_module"
                      && name != "_ref"
                      && value != null
                  );

            recursiveSanitized = lib.mapAttrs (lib.const sanitize) stripped;
          in
            if ( length (attrNames configuration) == 0)
            then
              null
            else
              recursiveSanitized;
      };


  # evaluate given config.
  # also include all the default modules
  evaluateConfiguration = configuration:
    with lib;
    evalModules {
      modules = [
        {
          imports = [
            ./terraform-core-options.nix
            ./provider-modules
            ./provider
          ];
        }
        configuration
      ];
  };

  # create the final result
  # by whitelisting every
  # parameter which is needed by terraform
  terranix = configuration: 
    let
      result = sanitize (evaluateConfiguration configuration).config;
      #result = (evaluateConfiguration configuration).config;
      # todo : make simpler
      ifPush = value: object: if value != null then object else {};
    in
      {}
      // (ifPush  result.provider { provider = result.provider; })
      // (ifPush  result.variable { variable = result.variable; })
      // (ifPush  result.resource { resource = result.resource; })
      // (ifPush  result.data     { data     = result.data; })
      // (ifPush  result.output   { output   = result.output; });

in terranix
  {
    imports = [ <config> ];
  }

