# terranix core
# -------------

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
            if ( length ( attrNames configuration ) == 0 )
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
            ./terraform-options.nix
            ../modules
            # ./provider
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
      whitelist = key: if result."${key}" != null then { "${key}" = result."${key}"; } else {};
    in
      {}
      // (whitelist "data")
      // (whitelist "output")
      // (whitelist "provider")
      // (whitelist "resource")
      // (whitelist "variable")
      // (whitelist "terraform");

in terranix
  {
    imports = [ <config> ];
  }

