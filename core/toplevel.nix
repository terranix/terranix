# entry point for terranix

let
  configuration = import ./default.nix {
    modules = { imports = [ <config> ]; };
  };
in

configuration.config
