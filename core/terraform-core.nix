
self:

with self;
with self.lib;
with builtins;

let

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

      ifPush = value: object: if value != null then object else {};
    in
      {}
      // (ifPush  result.provider { provider = result.provider; })
      // (ifPush  result.variable { variable = result.variable; })
      // (ifPush  result.resource { resource = result.resource; })
      // (ifPush  result.data { data = result.data; })
      // (ifPush  result.output { provider = result.output; });

}
