# terranix core
# -------------
{ pkgs ? import <nixpkgs> { }
, extraArgs ? { }
, terranix_config
, strip_nulls ? true
}:

with pkgs.lib;
with builtins;

let

  # sanitize the resulting configuration
  # removes unwanted parts of the evalModule output
  sanitize = configuration:
    getAttr (typeOf configuration) {
      bool = configuration;
      int = configuration;
      float = configuration;
      string = configuration;
      str = configuration;
      list = map sanitize configuration;
      null = null;
      set =
        let
          pred = name: value: name != "_module" && name != "_ref" && name != "__functor";
          stripped_a = flip filterAttrs configuration
            (name: value: pred name value);
          stripped_b = flip filterAttrs configuration
            (name: value: pred name value && value != null);
          recursiveSanitized =
            if strip_nulls then
              mapAttrs (const sanitize) stripped_b
            else
              mapAttrs (const sanitize) stripped_a;
        in
        if (length (attrNames configuration) == 0) then
          { }
        else
          recursiveSanitized;
    };

  # pkgs.lib extended with terranix-specific utils
  lib' = pkgs.lib.extend (import ./helpers.nix pkgs);

  # evaluate given config.
  # also include all the default modules
  # https://github.com/NixOS/nixpkgs/blob/master/lib/modules.nix#L95
  evaluateConfiguration = configuration:
    lib'.evalModules {
      modules = [
        { imports = [ ./terraform-options.nix ../modules ]; }
        { _module.args = { inherit pkgs; }; }
        configuration
      ];
      specialArgs = extraArgs;
    };

  # create the final result
  # by whitelisting every
  # parameter which is needed by terraform
  terranix = configuration:
    let
      evaluated = evaluateConfiguration configuration;
      result = sanitize evaluated.config;
      genericWhitelist = f: key:
        let attr = f result.${key};
        in
        if attr == { } || attr == null
        then { }
        else {
          ${key} = attr;
        };
      whitelist = genericWhitelist id;
      whitelistWithoutEmpty = genericWhitelist (filterAttrs (name: attr: attr != { }));
    in
    {
      config = { } //
        (whitelistWithoutEmpty "data") //
        (whitelist "import") //
        (whitelist "locals") //
        (whitelist "module") //
        (whitelist "output") //
        (whitelist "provider") //
        (whitelistWithoutEmpty "resource") //
        (whitelist "terraform") //
        (whitelist "variable");
    };

in
terranix terranix_config

