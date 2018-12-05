
self:

with self;
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
    f = x: with lib; evalModules {
      modules = [
        {
          options = {
            provider = mkOption {
              type = types.listOf types.attrs;
              default = [];
            };
            resource = mkOption {
              type = types.attrs;
              default = {};
            };
          };
        }
        x
      ]  ;
    };
  in
    # x: sanitize (f x).config;
    x: (f x).config;
}
