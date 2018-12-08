
self:

with self;
with self.lib;
with builtins;

let

 sanitize = configuration: lib.getAttr (typeOf configuration) {
        bool = configuration;
        int = configuration;
        list = map sanitize configuration;
        set = lib.mapAttrs
                (lib.const sanitize)
                (lib.filterAttrs
                  (name: value: (name != "_module" && name != "_ref") && value != null) configuration);
        string = configuration;
      };
in {

  eval =
  let

    evaluateConfiguration = configuration:
      with lib;
      evalModules {
        modules = [
          {
            imports = [
              ./coreOptions.nix
              ./modules
              ./provider
            ];
          }
          configuration
        ];
    };
  in
    configuration: let
      result = sanitize (evaluateConfiguration configuration).config;
      #result = (evaluateConfiguration configuration).config;
    in {
      provider = result.provider;
      variable = result.variable;
      resource = result.resource;
      data = result.data;
      output = result.output;
    };
}
