
self:

with self;
with self.lib;
with builtins;

let

 sanitize = x: lib.getAttr (typeOf x) {
        bool = x;
        list = map sanitize x;
        set = lib.mapAttrs
                (lib.const sanitize)
                (lib.filterAttrs
                  (name: value: name != "_module" && value != null) x);
        string = x;
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
      result = (evaluateConfiguration configuration).config;
    in { 
      provider = result.provider;
      variable = result.variable;
      resource = result.resource;
    };
}
