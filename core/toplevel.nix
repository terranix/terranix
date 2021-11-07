# entry point for terranix

let
  configuration = import ./default.nix {
    terranix_config = { imports = [ <config> ]; };
  };
in

configuration.config
