{ pkgs ?  import <nixpkgs> {} }:

# with pkgs.lib;

let
  myModules = [
                ./core/modules/cloudflare/default.nix
                ./core/modules/hetzner/default.nix
                ./core/coreOptions.nix
              ];
   # config = { meta = { doc = [] ; } ; };
   config = (import <nixpkgs/nixos/lib/eval-config.nix> { modules = myModules; }).config;
   mkManual = modList: import <nixpkgs/nixos/doc/manual> rec {
    inherit pkgs config;
    #inherit pkgs;
    # version = config.system.nixos.release;
    version = "10";
    revision = "release-${version}";
    options = let
      scrubbedEval = pkgs.lib.evalModules {
        # modules = [ { nixpkgs.localSystem = config.nixpkgs.localSystem; } ] ++ (import <helsinki/3modules>) ++ modList;
        modules = modList;
        # args = (config._module.args) // { modules = [ ]; };
        # specialArgs = { pkgs = scrubDerivations "pkgs" pkgs; };
      };
      #scrubDerivations = namePrefix: pkgSet: mapAttrs
      #  (name: value:
      #    let wholeName = "${namePrefix}.${name}"; in
      #    if isAttrs value then
      #      scrubDerivations wholeName value
      #      // (optionalAttrs (isDerivation value) { outPath = "\${${wholeName}}"; })
      #    else value
      #  )
      #  pkgSet;
      in
        scrubbedEval.options;
  };

in pkgs.mkShell {

  # needed pkgs
  # -----------
  buildInputs = with pkgs; [
    ((mkManual myModules).manpages)
  ];

  # run this on start
  # -----------------
  shellHook = ''

  HISTFILE=${toString ./.}/.history

  '';
}
