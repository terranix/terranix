
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
                  (name: value: name != "_module" && value != null) configuration);
        string = configuration;
      };
in {

  eval =
  let

    coreOptions = {
      options = {
        variable = mkOption {
          type = with types; listOf attrs;
          default = [];
        };
        provider = mkOption {
          type = with types; listOf attrs;
          default = [];
        };
        resource = mkOption {
          type = with types; attrsOf attrs;
          default = {};
        };
      };
    };

    evaluateConfiguration = configuration: 
      with lib; 
      evalModules {
        modules = [
          coreOptions
          configuration 
        ];
    };
  in
    configuration: let
      result = sanitize (evaluateConfiguration configuration).config;
    in { 
      provider = result.provider;
      variable = result.variable;
      resource = result.resource;
    };
}
