# terranix core
# -------------
{ terranix_config, strip_nulls ? true }:

let pkgs = import <nixpkgs> { };

in with pkgs;
with pkgs.lib;
with builtins;

let

  # sanitize the resulting configuration
  # removes unwanted parts of the evalModule output
  sanitize = configuration:
    lib.getAttr (typeOf configuration) {
      bool = configuration;
      int = configuration;
      string = configuration;
      str = configuration;
      list = map sanitize configuration;
      null = null;
      set = let
        stripped_a = lib.flip lib.filterAttrs configuration
          (name: value: name != "_module" && name != "_ref");
        stripped_b = lib.flip lib.filterAttrs configuration
          (name: value: name != "_module" && name != "_ref" && value != null);
        recursiveSanitized = if strip_nulls then
          lib.mapAttrs (lib.const sanitize) stripped_b
        else
          lib.mapAttrs (lib.const sanitize) stripped_a;
      in if (length (attrNames configuration) == 0) then
        null
      else
        recursiveSanitized;
    };

  # evaluate given config.
  # also include all the default modules
  evaluateConfiguration = configuration:
    with lib;
    evalModules {
      modules =
        [ { imports = [ ./terraform-options.nix ../modules ]; } configuration ];
      specialArgs = { inherit pkgs; };
    };

  # create the final result
  # by whitelisting every
  # parameter which is needed by terraform
  terranix = configuration:
    let
      evaluated = evaluateConfiguration configuration;
      result = sanitize evaluated.config;
      whitelist = key:
        if result."${key}" != null then {
          "${key}" = result."${key}";
        } else
          { };
    in {
      config = { } // (whitelist "data") // (whitelist "locals")
        // (whitelist "module") // (whitelist "output")
        // (whitelist "provider") // (whitelist "resource")
        // (whitelist "terraform") // (whitelist "variable");
    };

in terranix terranix_config

